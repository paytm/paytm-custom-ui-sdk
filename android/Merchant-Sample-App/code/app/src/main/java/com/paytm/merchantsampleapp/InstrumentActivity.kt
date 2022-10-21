package com.paytm.merchantsampleapp

import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.content.res.ColorStateList
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.Typeface
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.text.Editable
import android.text.TextUtils
import android.text.TextWatcher
import android.util.Log
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import com.android.volley.VolleyError
import com.google.gson.Gson
import com.paytm.merchantsampleapp.model.*
import kotlinx.android.synthetic.main.activity_instruments.*
import kotlinx.android.synthetic.main.activity_instruments.fetch_nb_channels
import kotlinx.android.synthetic.main.instrument_card.*
import kotlinx.android.synthetic.main.instrument_nb.*
import kotlinx.android.synthetic.main.instrument_tokenized_card.*
import kotlinx.android.synthetic.main.instrument_upi.*
import kotlinx.android.synthetic.main.saved_card_view.*
import net.one97.paytm.nativesdk.PaytmSDK
import net.one97.paytm.nativesdk.Utils.PayMethodType
import net.one97.paytm.nativesdk.Utils.Server
import net.one97.paytm.nativesdk.app.CardProcessTransactionListener
import net.one97.paytm.nativesdk.app.CheckLoggedInUserMatchListener
import net.one97.paytm.nativesdk.app.PaytmSDKCallbackListener
import net.one97.paytm.nativesdk.common.widget.PaytmConsentCheckBox
import net.one97.paytm.nativesdk.dataSource.PaymentsDataImpl
import net.one97.paytm.nativesdk.dataSource.models.*
import net.one97.paytm.nativesdk.instruments.upicollect.models.UpiOptionsModel
import net.one97.paytm.nativesdk.paymethods.datasource.PaymentMethodDataSource
import net.one97.paytm.nativesdk.paymethods.model.processtransaction.ProcessTransactionInfo
import net.one97.paytm.nativesdk.transcation.model.TransactionInfo
import org.json.JSONObject
import java.nio.charset.Charset
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class InstrumentActivity : AppCompatActivity(), View.OnClickListener, CardProcessTransactionListener {

    /*
    * Please read readme file before starting
    */

    private var paytmSDK: PaytmSDK? = null
    private var vpaDetail: List<VpaAccountDetail>? = emptyList()
    private var vpaBankDetail: List<VpaBankAccountDetail>? = emptyList()
    private var binResponse: JSONObject? = null
    private var bankCode: String? = null
    private var channelCode: String? = null
    private lateinit var paymentMode: String
    private val cardTypes = arrayOf("Credit Card", "Debit Card")

    private lateinit var amount: String

    private var upiAppListAdapter: UpiAppListAdapter? = null
    private var upiAppsInstalled: ArrayList<UpiOptionsModel>? = null

    private lateinit var mid: String
    private lateinit var orderid: String
    private lateinit var txnToken: String
    private var pd: AlertDialog? = null


    private val cardExpiryTextWatcher = object : TextWatcher {
        override fun afterTextChanged(characters: Editable?) {
            if (characters?.length?.compareTo(0) ?: -1 > 0 && characters?.length == 3) {
                val c = characters[characters.length - 1]
                if ('/' == c) {
                    characters.delete(characters.length - 1, characters.length)
                }
            }
            if (characters?.length?.compareTo(0) ?: -1 > 0 && characters?.length == 3) {
                val c = characters[characters.length - 1]
                if (Character.isDigit(c)) {
                    characters.insert(characters.length - 1, '/'.toString())
                }
            }
        }

        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }
    }

    private val cardNumberTextWatcher = object : TextWatcher {
        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }

        override fun afterTextChanged(s: Editable?) {
            val cardNumber = s.toString()
            val cardLength = cardNumber.length
            if (cardNumber.length >= 6 && binResponse == null) {
                getBinResponse(cardNumber)
            } else if (cardLength < 6) {
                binResponse = null
            }
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_instruments)
        initPaytmSDK()
        init()
        initUpiPushCards()
        setUpiIntentItems()
    }

    // Creating paytmSDK instance to fetch allowed options and details
    private fun initPaytmSDK() {
        mid = intent.getStringExtra("mid") ?: ""
        orderid = intent.getStringExtra("orderId")
        amount = intent.getStringExtra("amount") ?: "0"
        txnToken = intent.getStringExtra("txnToken") ?: ""
        val isStaging = intent.getBooleanExtra("isStaging",false)

        val builder =
            PaytmSDK.Builder(
                this,
                mid,
                orderid,
                txnToken,
                java.lang.Double.parseDouble(amount),
                this
            )

        //no need to add setMerchantCallbackUrl is you are using static paytm callback -> Constants.callBackUrl + orderId
//        builder.setMerchantCallbackUrl("custom url only if callback is required on you page")

        if (isStaging) {
            PaytmSDK.setServer(Server.STAGING)
        } else {
            PaytmSDK.setServer(Server.PRODUCTION)
        }

        paytmSDK = builder.build()
    }

    private fun init() {
        saved_instrument.setOnClickListener(this)
        proceed_tokenized_card.setOnClickListener(this)
        fetch_nb_channels.setOnClickListener(this)
        proceed_card.setOnClickListener(this)
        proceed_saved_card.setOnClickListener(this)
        proceed_wallet.setOnClickListener(this)
        proceed_nb.setOnClickListener(this)
        proceed_upi.setOnClickListener(this)

        action_emi_details.setOnClickListener(this)
        saved_nb.setOnClickListener(this)
        saved_vpa_upi_collect.setOnClickListener(this)
        btn_check_match.setOnClickListener(this)
        tvValidateVPA.setOnClickListener(this)


        add_money_wallet.setOnClickListener(this)

        tv_customizeCheckbox.setOnClickListener {
            val intent = Intent(this, CheckboxCustomisation::class.java)
            startActivityForResult(intent, 1234)
        }

        fetch_authcode.setOnClickListener { fetchAuthCode() }

        card_expiry.addTextChangedListener(cardExpiryTextWatcher)
        card_expiry.setRawInputType(Configuration.KEYBOARD_QWERTY)

        card_number.addTextChangedListener(cardNumberTextWatcher)

        card_type_view.setOnClickListener { card_container.toggleVisibility() }
        saved_card_type_view.setOnClickListener { card1_container.toggleVisibility() }
        tokenized_card_type_view.setOnClickListener { card2_container.toggleVisibility()}


        setUpCardSpinner()
    }

    // if allowed setting upi push view for available upi of current users
    private fun initUpiPushCards() {
        vpaDetail =
            AppRepo.cjPayMethodResponse?.body?.merchantPayOption?.upiProfile?.respDetails?.profileDetail?.vpaDetails
        vpaBankDetail =
            AppRepo.cjPayMethodResponse?.body?.merchantPayOption?.upiProfile?.respDetails?.profileDetail?.bankAccounts

        vpaBankDetail?.forEachIndexed { i, item ->
            val inflater = LayoutInflater.from(this)
            val upiItem = inflater.inflate(R.layout.upi_push_item, upi_push_container, false)
            val tvBalance = upiItem.findViewById<Button>(R.id.tvBalance)
            val tvUpiPushPay = upiItem.findViewById<Button>(R.id.tvUpiPushPay)
            val tvSetMpin = upiItem.findViewById<Button>(R.id.tvSetMpin)
            upiItem.findViewById<TextView>(R.id.tvTitle).text = item.bank
            upi_push_container.addView(upiItem)

            tvBalance.tag = i
            tvBalance.setOnClickListener(this)

            tvUpiPushPay.tag = i
            tvUpiPushPay.setOnClickListener(this)

            tvSetMpin.tag = i
            tvSetMpin.setOnClickListener(this)
        }
    }

    //Adding available UPI apps like paytm, google pay etd
    private fun setUpiIntentItems() {
        try {
            val upiDeepLink = Uri.Builder()
            upiDeepLink.scheme("upi").authority("pay")

            upiAppsInstalled =
                PaytmSDK.getPaymentsHelper().getUpiAppsInstalled(this)
            if (upiAppsInstalled != null) {
                upiAppListAdapter =
                    UpiAppListAdapter(upiAppsInstalled,
                        UpiAppListAdapter.OnClickUpiApp { upiOptionsModel, _ ->
                            val upiIntentDataRequestModel = UpiIntentRequestModel(
                                "NONE",
                                upiOptionsModel.appName,
                                upiOptionsModel.resolveInfo.activityInfo
                            )
                            showDialog()
                            paytmSDK?.startTransaction(
                                this@InstrumentActivity, upiIntentDataRequestModel
                            )
                        })

                val gridLayoutManager =
                    object : androidx.recyclerview.widget.GridLayoutManager(this, 5) {
                        override fun canScrollVertically(): Boolean {
                            return false
                        }
                    }

                upi_apps.apply {
                    layoutManager = gridLayoutManager
                    adapter = upiAppListAdapter
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    override fun onClick(v: View?) {
        when (v?.id) {
            R.id.btn_check_match -> {
                checkIFUserMatches(et_mobile_no.text?.toString())
            }

            R.id.saved_instrument -> {
                fetchIfSavedInstruments()
            }
            R.id.fetch_nb_channels -> {
                fetchNetBankingList()
            }
            R.id.tvUpiPushPay -> {
                val tag = v.tag as? Int ?: 0
                //Using first element from vpaDetail list only. Change in future if multiple VPA are allowed
                val vpaDetail = vpaDetail?.get(0)
                val vpaBankDetail = vpaBankDetail?.get(tag)
                goForUpiPushTransaction(vpaDetail, vpaBankDetail)

            }
            R.id.tvSetMpin -> {
                val tag = v.tag as? Int ?: 0

                val vpaDetail = vpaDetail?.get(0)
                val vpaBankDetail = vpaBankDetail?.get(tag)

                val vpaDetailString = Gson().toJson(vpaBankDetail!!)

                val upiDataRequestModel =
                    UpiDataRequestModel(vpaDetail?.name!!, vpaDetailString!!)
                paytmSDK?.setUpiMpin(this, upiDataRequestModel)
            }
            R.id.tvBalance -> {
                val tag = v.tag as? Int ?: 0

                val vpaDetail = vpaDetail?.get(0)
                val vpaBankDetail = vpaBankDetail?.get(tag)

                val vpaDetailString = Gson().toJson(vpaBankDetail)

                val upiDataRequestModel =
                    UpiDataRequestModel(vpaDetail?.name!!, vpaDetailString!!)
                paytmSDK?.fetchUpiBalance(this, upiDataRequestModel)
            }
            R.id.proceed_card, R.id.proceed_saved_card, R.id.proceed_nb, R.id.proceed_upi, R.id.proceed_tokenized_card -> {
                startTransaction(v.id)
            }
            R.id.action_emi_details -> {
                fetchEmiDetails()
            }
            R.id.saved_nb -> {
                var bank = PaytmSDK.getPaymentsUtilRepository().getLastNBSavedBank()
                bank = if (bank.isNullOrEmpty()) {
                    "No Saved Bank Found"
                } else {
                    "Last Saved Bank: $bank"
                }
                showToast(bank)
            }
            R.id.saved_vpa_upi_collect -> {
                var vpa = PaytmSDK.getPaymentsUtilRepository().getLastSavedVPA()
                vpa = if (vpa.isNullOrEmpty()) {
                    "No Saved VPA Found"
                } else {
                    "Last Saved VPA: $vpa"
                }
                showToast(vpa)
            }
            R.id.proceed_wallet -> {
                goForWalletTransaction()
            }
            R.id.add_money_wallet -> {
                paytmSDK?.openPaytmAppForAddMoneyToWallet(this)
            }
            R.id.tvValidateVPA -> {
                val vpa = validateVpaText.text?.toString()
                val vpaAddress = if(cbIsNumeric.isChecked) null else vpa
                val numericId = if(cbIsNumeric.isChecked) vpa else null
                PaymentsDataImpl.validateVPA(
                    vpaAddress,
                    mid, "TXN_TOKEN", txnToken, orderid, object : PaymentMethodDataSource.Callback<VPAValidateResponse> {
                        override fun onResponse(response: VPAValidateResponse?) {
                            if (response?.isValid == true) {
                                if(cbIsNumeric.isChecked && response.vpa != null) {
                                    Toast.makeText(applicationContext, "vpa : " + response.vpa, Toast.LENGTH_SHORT).show()
                                }
                                Toast.makeText(applicationContext, "VPA Validated", Toast.LENGTH_SHORT).show()
                            } else {
                                Toast.makeText(applicationContext, "VPA Not Validated " + response?.resultMsg, Toast.LENGTH_SHORT).show()
                            }
                        }

                        override fun onErrorResponse(error: VolleyError?, errorInfo: VPAValidateResponse?) {
                            Toast.makeText(applicationContext, "Error in API", Toast.LENGTH_SHORT).show()
                        }
                    },numericId)
            }
        }
    }

    private fun goForWalletTransaction() {
        if(checkIfWalletBalanceSufficient(amount)) {
            val paymentRequestModel =
                WalletRequestModel(AppRepo.cjPayMethodResponse?.body?.paymentFlow!!)

            paytmSDK?.startTransaction(this, paymentRequestModel)
        }else{
            wallet_insuff_ll.visibility = View.VISIBLE
        }
    }

    private fun checkIfWalletBalanceSufficient(amount: String): Boolean {
        val walletAmt = getWalletBalance()
        val amt = amount.toFloat()
        return walletAmt >= amt
    }

    fun getWalletBalance(): Float {
        val merchantPayMethodList = AppRepo.cjPayMethodResponse?.body?.merchantPayOption

        if (merchantPayMethodList == null) {
            return 0f
        } else {
            val paymentModes = merchantPayMethodList.paymentModes
            if (paymentModes != null) {
                val itr = paymentModes.iterator()

                while (itr.hasNext()) {
                    val m = itr.next() as PaymentModes
                    if (m.paymentMode == "BALANCE" && !(m.payChannelOptions == null || m.payChannelOptions.size == 0)) {
                        val option = m.payChannelOptions[0]
                        if (option.balanceInfo != null && option.balanceInfo.accountBalance != null) {
                            return option.balanceInfo.accountBalance.value.toFloat()
                        }
                    }
                }
            }
            return 0f
        }
    }


    // when paytm app is available this checks if there is any saved instruments
    private fun fetchIfSavedInstruments() {
        val hasSavedInstrument = PaytmSDK.getPaymentsUtilRepository()
            .userHasSavedInstruments(this, mid, true, true, true)
        showToast("Has instruments : $hasSavedInstrument")
    }

    // fetch available net banking channel code
    private fun fetchNetBankingList() {
        try {
            PaytmSDK.getPaymentsHelper()
                .getNBList(object : PaymentMethodDataSource.Callback<JSONObject> {
                    override fun onResponse(response: JSONObject?) {
                        showToast(getMessage(response))
                    }

                    override fun onErrorResponse(error: VolleyError?, errorInfo: JSONObject?) {
                        showToast(
                            "Error fetching NB List :" + getMessage(errorInfo)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    //Start upi push transaction
    private fun goForUpiPushTransaction(
        vpaDetail: VpaAccountDetail?,
        vpaBankDetail: VpaBankAccountDetail?
    ) {
        showDialog()
        vpaDetail?.let {
            val paymentFlow = AppRepo.cjPayMethodResponse?.body?.paymentFlow ?: "NONE"
            val merchantDetails = AppRepo.cjPayMethodResponse?.body?.merchantDetails

            val merchantDetailsString = Gson().toJson(merchantDetails)
            val bankAccountString = Gson().toJson(vpaBankDetail!!)


            val upiPushRequestModel =
                UpiPushRequestModel(
                    paymentFlow = paymentFlow,
                    upiId = vpaDetail.name!!,
                    bankAccountJson = bankAccountString,
                    merchantDetailsJson = merchantDetailsString
                )

            paytmSDK?.startTransaction(this, upiPushRequestModel)
        } ?: kotlin.run {
            dismissDialog()
            showToast("Bank rAccount details are null")
        }
    }

    //start tokenized card transaction
    private fun goForTokenizedCard(){
        val cardToken = cardToken.text?.toString()
        val tokenExpiry = tokenExpiry.text?.toString()
        val tavv = etTavv.text?.toString()

        val cardCvv = tokenized_card_cvv.text?.toString()
        val emiChannelId: String? = card_emichannelId?.text.toString()

        val lastFourDigits = etLastFourDigits.text?.toString()
        val par = etPar.text?.toString()
        val channelCode = etBankCode.text?.toString()
        val bankCode = etChannelCode.text?.toString()

        val cardPayModeType: String = if (card_type.selectedItem.toString() == "Credit Card") {
            PayMethodType.CREDIT_CARD
        } else {
            PayMethodType.DEBIT_CARD
        }

        val otpChecked = rg_auth_mode_card.findViewById<RadioButton>(R.id.rb_otp_card).isChecked
        val pinChecked = rg_auth_mode_card.findViewById<RadioButton>(R.id.rb_pin_card).isChecked

        var authMode = "otp"
        if (otpChecked) {
            authMode = "otp"
        } else if(pinChecked) {
            authMode = "pin"
        }

        paymentMode = cardPayModeType
        val cardRequestModel = TokenizedCardRequestModel(
            paymentMode,
            AppRepo.cjPayMethodResponse?.body?.paymentFlow!!,
            cardToken!!,
            tokenExpiry!!,
            tavv!!,
            lastFourDigits!!,
            par!!,
            authMode,
            cardCvv!!,
            emiChannelId,
            bankCode,
            channelCode
        )
        paytmSDK?.startTransaction(this, cardRequestModel)
    }

    //Start new card transaction
    private fun goForNewCardTransaction(): PaymentRequestModel {
        val shouldSaveCard = cb_save_card.isChecked
        val isMerchantPoweredBankPages = cb_get_ptc_new.isChecked
        val cardNumber = card_number.text?.toString()
        val cardCvv = card_cvv.text?.toString()
        val cardExpiry = card_expiry?.text.toString()

        val otpChecked = rg_auth_mode_nc.findViewById<RadioButton>(R.id.rb_otp).isChecked
        val pinChecked = rg_auth_mode_nc.findViewById<RadioButton>(R.id.rb_pin).isChecked
        var authMode = "otp"
        if (otpChecked) {
            authMode = "otp"
        } else if (pinChecked) {
            authMode = "pin"
        }

        val cardPayModeType = if (card_type.selectedItem.toString() == "Credit Card") {
            PayMethodType.CREDIT_CARD
        } else {
            PayMethodType.DEBIT_CARD
        }

        paymentMode = getBinPaymentMode(
            binResponse,
            cardPayModeType == PayMethodType.CREDIT_CARD
        )

        val isEligibleForCoFT = getBinDetail(binResponse!!)?.isEligibleForCoFT ?: false


        return CardRequestModel(
            paymentMode,
            AppRepo.cjPayMethodResponse?.body?.paymentFlow!!,
            cardNumber,
            null,
            cardCvv!!,
            cardExpiry,
            bankCode,
            channelCode,
            authMode,
            null,
            shouldSaveCard,
            isEligibleForCoFT,
            true,
            isMerchantPoweredBankPages
        )
    }

    // get type of card visa, mastercard etc
    private fun getBinPaymentMode(binResponse: JSONObject?, isCreditCardLayout: Boolean): String {
        if (binResponse != null) {
            val binDetail = getBinDetail(binResponse)
            if (binDetail != null) {
                val binPaymentMode = binDetail.paymentMode
                if (!TextUtils.isEmpty(binPaymentMode)) {
                    return binPaymentMode
                }
            }
        }
        return if (isCreditCardLayout) PayMethodType.CREDIT_CARD else PayMethodType.DEBIT_CARD
    }

    private fun getBinDetail(response: JSONObject): BinDetail? {
        var binDetail:CJPayMethodResponse
        try {
            binDetail = Gson().fromJson(response.toString(),CJPayMethodResponse::class.java)
            return binDetail.body.binDetail
        }catch (e: Exception){
            e.printStackTrace()
        }
        return null
    }

    // card that is already saved at user end
    private fun goForSavedCardTransaction(): PaymentRequestModel {
        val cardId = saved_card_id.text?.toString()
        val cardCvv = saved_card_cvv.text?.toString()
        val emiChannelId: String? = saved_card_emichannelId?.text.toString()

        val cardPayModeType = if (saved_card_type.selectedItem.toString() == "Credit Card") {
            PayMethodType.CREDIT_CARD
        } else {
            PayMethodType.DEBIT_CARD
        }

        paymentMode = cardPayModeType

        val otpChecked = rg_auth_mode_sc.findViewById<RadioButton>(R.id.rb_otp).isChecked
        val pinChecked = rg_auth_mode_sc.findViewById<RadioButton>(R.id.rb_pin).isChecked
        var authMode = "otp"
        if (otpChecked) {
            authMode = "otp"
        } else if (pinChecked) {
            authMode = "pin"
        }

        val userConsentGiven = cbUserConsent.isChecked

        val bankDetails = getBankDetails(cardId)
        channelCode = bankDetails?.get("cardScheme")
        bankCode = bankDetails?.get("bankCode")

        val isEligibleForCoFT = bankDetails?.get("isEligibleForCoFT") == "1"
        val isMerchantPoweredBankPages = cb_get_ptc.isChecked

        return CardRequestModel(
            paymentMode,
            AppRepo.cjPayMethodResponse?.body?.paymentFlow!!,
            null,
            cardId,
            cardCvv!!,
            null,
            bankCode,
            channelCode,
            authMode,
            emiChannelId,
            true,
            isEligibleForCoFT,
            userConsentGiven,
            isMerchantPoweredBankPages
        )
    }


    // setting PaymentRequestModel for respective transaction
    private fun startTransaction(id: Int) {
        showDialog()
        var paymentRequestModel: PaymentRequestModel? = null
        when (id) {
            R.id.proceed_saved_card -> {
                paymentRequestModel = goForSavedCardTransaction()
            }

            R.id.proceed_nb -> {
                val nbCode = edt_nb.text?.toString()
                if (!nbCode.isNullOrBlank()) {
                    paymentRequestModel =
                        NetBankingRequestModel(
                            AppRepo.cjPayMethodResponse?.body?.paymentFlow!!,
                            nbCode
                        )
                }
            }

            R.id.proceed_tokenized_card -> {
                goForTokenizedCard()
            }

            R.id.proceed_upi -> {
                val upiCode = edt_upi.text?.toString()
                val saveVPA = cb_save_vpa.isChecked
                if (!TextUtils.isEmpty(upiCode)) {
                    paymentRequestModel =
                        UpiCollectRequestModel(
                            AppRepo.cjPayMethodResponse?.body?.paymentFlow!!,
                            upiCode!!,
                            saveVPA
                        )
                }
            }
            R.id.proceed_card -> {
                val cardNumber = card_number.text?.toString()
                if (!cardNumber.isNullOrBlank()) {
                    paymentRequestModel = goForNewCardTransaction()
                }
            }
        }
        if (paymentRequestModel != null) {
            paytmSDK?.startTransaction(this, paymentRequestModel)
        } else {
            dismissDialog()
            showToast("paymentModel is nulll")
        }
    }

    private fun checkIFUserMatches(mobilenumber: String?) {
        getmobileSHA(mobilenumber)?.let {
            PaytmSDK.getPaymentsUtilRepository().checkIfLoggedInUserMobNoMatched(this,it,object :
                CheckLoggedInUserMatchListener {
                override fun getIfUserMatched(case: Int) {
                    showToast("User Matches case $case")
                }

            })
        }
    }

    private fun getmobileSHA(mobilenumber: String?): String? {
        return try {
            if(TextUtils.isEmpty(mobilenumber)) return ""
            val md: MessageDigest = MessageDigest.getInstance("SHA-256")
            md.reset()
            val hashedBytes: ByteArray = md.digest(mobilenumber?.toByteArray(Charset.forName("UTF-8")))
            String(hashedBytes,Charset.forName("UTF-8"))
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
            null
        }
    }

    //fetch emi details available for card
    private fun fetchEmiDetails() {
        showDialog()
        val cardPayModeType = if (card_type.selectedItem.toString() == "Credit Card") {
            PayMethodType.CREDIT_CARD
        } else {
            PayMethodType.DEBIT_CARD
        }
        paymentMode = getBinPaymentMode(
            binResponse,
            cardPayModeType == PayMethodType.CREDIT_CARD
        )

        val channelCode = binResponse?.let { getBinDetail(it)?.issuingBankCode }

        if (!TextUtils.isEmpty(channelCode)) {
            PaytmSDK.getPaymentsHelper().getEMIDetails(this, channelCode!!, paymentMode,
                object : PaymentMethodDataSource.Callback<JSONObject> {
                    override fun onErrorResponse(error: VolleyError?, errorInfo: JSONObject?) {
                        showToast(
                            getMessage(errorInfo)
                        )
                        dismissDialog()
                    }

                    override fun onResponse(response: JSONObject?) {
                        val emi = Gson().toJson(response)
                        tv_emidetails.text = emi
                        dismissDialog()
                    }
                })
        } else {
            dismissDialog()
            showToast("Error fetching card details")
        }
    }

    //get bank detail
    private fun getBankDetails(cardId: String?): HashMap<String, String>? {
        val result = HashMap<String, String>()
        val list = AppRepo.cjPayMethodResponse?.body?.merchantPayOption?.savedInstruments
        if (list != null && list.size > 0) {
            for (i in 0 until list.size) {
                if (list[i].cardDetails?.cardId.equals(cardId)) {
                    result["bankCode"] = list[i].issuingBank
                    result["cardScheme"] = list[i].channelCode
                    result["isEligibleForCoFT"] = if(list[i].isEligibleForCoFT) "1" else "0"
                }
            }
        }
        return result
    }

    //callback for  upi intent result, upi push - checkbalance, pay, setMpin result
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        dismissDialog()
         if (requestCode == 1234 && data != null) {
            customizePaytmConsentCheckbox(data)
        }
    }

    /*
     * fetching authcode from paytm app if installed
     * if auth code is fetched pass it to your server while create transaction token to access all
     * methods else you can't use wallet, UPI push and saved cards methods
     */
    private fun fetchAuthCode() {
        val paymentsUtilRepository = PaytmSDK.getPaymentsUtilRepository()
        if (paymentsUtilRepository.isPaytmAppInstalled(this)) {
            if (edt_client_id.text.toString().isEmpty()) {
                Toast.makeText(this, "Enter Client id", Toast.LENGTH_LONG).show()
                return
            }
            val code: String? = paymentsUtilRepository.fetchAuthCode(
                this,
                edt_client_id.text.toString(),
                mid
            )
            Toast.makeText(this, "authCode = $code", Toast.LENGTH_LONG).show()
            //if auth code is fetched then pass it to your server while create transaction token to access all methods
        } else {
            Toast.makeText(this, "App not installed", Toast.LENGTH_LONG).show()
            //you can't use wallet, UPI push and saved cards methods but you can generate transaction token without it
        }
        // after receiving token call startTransaction
    }

    // checkbox customization using method
    private fun customizePaytmConsentCheckbox(intent: Intent) {
        val consentCheckbox: PaytmConsentCheckBox = findViewById(R.id.consentCheckbox)
        val textColor = intent.getIntExtra("text_color", -1)
        val textSize = intent.getFloatExtra("text_size", 0.0f)
        val bgColor = intent.getIntExtra("bg_color", -1)
        val c_color = intent.getIntExtra("checked_color", Color.rgb(0, 186, 242))
        val uc_color = intent.getIntExtra("unchecked_color", Color.GRAY)
        val t_font = intent.getIntExtra("font", -1)
        if (textColor != -1) {
            consentCheckbox.setTextColor(textColor)
        } else {
            consentCheckbox.setTextColor(Color.BLACK)
        }
        if (textSize != 0.0f) {
            consentCheckbox.textSize = textSize
        } else {
            consentCheckbox.setTextSize(
                TypedValue.COMPLEX_UNIT_PX,
                resources.getDimension(R.dimen.dimen_14sp)
            )
        }
        if (bgColor != -1) {
            consentCheckbox.setBackgroundColor(bgColor)
        } else {
            consentCheckbox.setBackgroundColor(Color.WHITE)
        }
        val myColorStateList = ColorStateList(arrayOf(intArrayOf(android.R.attr.state_checked), intArrayOf(-android.R.attr.state_checked)), intArrayOf(c_color, uc_color))
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            consentCheckbox.buttonTintList=myColorStateList
        }
        when (t_font) {
            1 -> consentCheckbox.typeface = Typeface.MONOSPACE
            2 -> consentCheckbox.typeface = Typeface.SANS_SERIF
            3 -> consentCheckbox.typeface = Typeface.SERIF
            -1 -> consentCheckbox.typeface = Typeface.DEFAULT
        }
    }

    //setting card spinner credit card and debit card for card transaction
    private fun setUpCardSpinner() {
        val adapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, cardTypes)
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        card_type.adapter = adapter
        saved_card_type.adapter = adapter
        tokenized_card_type.adapter = adapter
    }

    // read message from api reponse
    private fun getMessage(response: JSONObject?): String {
        var resultMsg = ""
        val body = response?.get("body") as JSONObject
        if (body.has("resultInfo")) {
            val resultInfo = body.get("resultInfo") as JSONObject
            if (resultInfo.has("resultMsg"))
                resultMsg = resultInfo.get("resultMsg") as String
        }
        return resultMsg
    }

    private fun showToast(context: Context, message: String) {
        Toast.makeText(context, message, Toast.LENGTH_LONG).show()
    }

    private fun showToast(message: String) {
        showToast(this, message)
    }

    // get callback for payment result
    override fun onTransactionResponse(p0: TransactionInfo?) {
        dismissDialog()
        if (p0 != null) {
            if (p0.txnInfo != null) {
                val s = Gson().toJson(p0.txnInfo)
                showToast(s)
                Log.d("MainActivity", " onTransactionResponse $s")
                finish()
            }
        }
    }

    override fun onGenericError(p0: Int, p1: String?) {
        dismissDialog()
        finish()
    }

    override fun networkError() {
        dismissDialog()
        finish()
    }

    override fun onBackPressedCancelTransaction() {
        dismissDialog()
        finish()
    }

    //get callback for merchant powered bank pages
    override fun onCardProcessTransactionResponse(processTransactionInfo: ProcessTransactionInfo?) {
        dismissDialog()
        if(processTransactionInfo != null) {
            val s = Gson().toJson(processTransactionInfo)
            showToast(s)
        }
    }


    private fun getBinResponse(cardSixDigit: String) {
        PaymentsDataImpl.fetchBinDetails(
            cardSixDigit, txnToken, "TXN_TOKEN", mid, orderid,
            object : PaymentMethodDataSource.Callback<JSONObject> {
                override fun onResponse(response: JSONObject?) {
                    onBinResponseApi(response)
                }

                override fun onErrorResponse(error: VolleyError?, errorInfo: JSONObject?) {

                }
            })
    }

    //setting paymentMode from bin response
    private fun onBinResponseApi(response: JSONObject?) {
        binResponse = response
        if (response != null) {
            val binDetail = getBinDetail(response)
            bankCode = binDetail?.issuingBankCode
            channelCode = binDetail?.channelCode
            binDetail?.paymentMode?.let { paymentMode = it }
        }
    }

    private fun View.toggleVisibility() {
        if (this.visibility == View.VISIBLE) {
            this.visibility = View.GONE
        } else {
            this.visibility = View.VISIBLE
        }
    }

    //while closing activity it is necessary to clear paytmSDK instance.
    //If clearPaytmSDKData is called, it is necessary to recreate PaytmConsentCheckBox view
    override fun onDestroy() {
        super.onDestroy()
        PaytmSDK.clearPaytmSDKData()
    }

    protected fun showDialog() {
        val dialog = AlertDialog.Builder(this)
        pd = dialog.create()
        pd!!.setMessage("please wait")
        pd!!.show()
    }

    protected fun dismissDialog() {
        if (pd != null && pd!!.isShowing) {
            pd!!.dismiss()
        }
    }

}