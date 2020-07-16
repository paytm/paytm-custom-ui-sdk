package com.paytm.merchantsampleapp;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.android.volley.DefaultRetryPolicy;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.paytm.merchantsampleapp.R;
import com.paytm.merchantsampleapp.model.CJPayMethodResponse;

import net.one97.paytm.nativesdk.Gtm.NativeSdkGtmLoader;
import net.one97.paytm.nativesdk.NetworkHandler.VolleyPostRequest;
import net.one97.paytm.nativesdk.NetworkHandler.VolleyRequestQueue;
import net.one97.paytm.nativesdk.PaytmSDK;
import net.one97.paytm.nativesdk.Utils.Server;
import net.one97.paytm.nativesdk.app.PaytmSDKCallbackListener;
import net.one97.paytm.nativesdk.common.Constants.SDKConstants;
import net.one97.paytm.nativesdk.dataSource.PaytmPaymentsUtilRepository;
import net.one97.paytm.nativesdk.transcation.model.TransactionInfo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class MainActivity extends Activity implements PaytmSDKCallbackListener {

    /*
     * Please read readme file before starting
     */

    EditText edtTxn, edtOrderid, edtMid, edtAmount;
    private CheckBox cbStaging;
    private PaytmPaymentsUtilRepository paymentsUtilRepository;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        edtMid = findViewById(R.id.edt_mid);
        edtTxn = findViewById(R.id.edt_txnToken);
        edtOrderid = findViewById(R.id.edt_orderid);
        edtAmount = findViewById(R.id.edt_amount);
        cbStaging = findViewById(R.id.cb_staging);

        checkAndRequestSmsPermission();
        findViewById(R.id.startTransaction).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startTransaction();
            }
        });

        findViewById(R.id.fetch_authcode).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                fetchAuthCode();
            }
        });
        paymentsUtilRepository = PaytmSDK.getPaymentsUtilRepository();
    }

    private void checkAndRequestSmsPermission() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.RECEIVE_SMS}, 102);
        }
    }


    @Override
    protected void onResume() {
        super.onResume();
    }

    /*
     * fetching authcode from paytm app if installed
     * if auth code is fetched pass it to your server while create transaction token to access all
     * methods else you can't use wallet, UPI push and saved cards methods
     */
    private void fetchAuthCode() {
        if (paymentsUtilRepository.isPaytmAppInstalled(this)) {
            String server = "pg-mid-test-prod";
            String authCode = paymentsUtilRepository.fetchAuthCode(this, server);
            Toast.makeText(this, "authCode = " + authCode, Toast.LENGTH_LONG).show();
            //if auth code is fetched then pass it to your server while create transaction token to access all methods
        } else {
            //you can't use wallet, UPI push and saved cards methods but you can generate transaction token without it
        }
        // after receiving token call startTransaction
    }

    /* already got transaction token from backend
     * now fetch pay options
     * You have to fetch this from your server as your server will have all the detail of user save instruments
     * with transaction token */
    private void startTransaction() {
        //This is just ot make paytmsdk point to staging
        if (cbStaging.isChecked()) {
            PaytmSDK.setServer(Server.STAGING);
        } else {
            PaytmSDK.setServer(Server.PRODUCTION);
        }
        fetchOptionsRequest();
    }

    /*
     * After receiving token and instument from
     * setting params for InstrumentActivity which is further used for fetching data
     */
    private void initPaytmSdk(String orderId) {
        String mid = edtMid.getText().toString();
        String amount = edtAmount.getText().toString();
        String txn = edtTxn.getText().toString();

        Intent intent = new Intent(this, InstrumentActivity.class);
        intent.putExtra("orderId", orderId);
        intent.putExtra("mid", mid);
        intent.putExtra("amount", amount);
        intent.putExtra("txnToken", txn);
        intent.putExtra("isStaging", cbStaging.isChecked());
        startActivity(intent);
    }

    //fetching all the payment option allowed for merchant
    private void fetchOptionsRequest() {
        String mid = edtMid.getText().toString();
        String fetchPayUrl = NativeSdkGtmLoader.getFetchPay(mid, edtOrderid.getText().toString());

        Request request = new VolleyPostRequest(Request.Method.POST, fetchPayUrl, null,
                null, createJsonForFetchAPI(SDKConstants.ALL_TYPE, edtTxn.getText().toString()), new Response.Listener() {
            @Override
            public void onResponse(Object response) {
                afterFetchPayOption((CJPayMethodResponse) response);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {

            }
        }, CJPayMethodResponse.class);
        executeRequest(request);
    }

    /*
        after fetching option setting it to AppRepo.setCjPayMethodResponse which is access later
        and then starting the Instrument activity
    */
    private void afterFetchPayOption(CJPayMethodResponse cjPayMethodResponse) {
        if (cjPayMethodResponse != null && cjPayMethodResponse.getBody() != null) {
//            if (rbNone.isChecked()) {
//                cjPayMethodResponse.getBody().setPaymentFlow("NONE");
//            } else {
//                cjPayMethodResponse.getBody().setPaymentFlow("ADDANDPAY");
//            }
            AppRepo.INSTANCE.setCjPayMethodResponse(cjPayMethodResponse);
            initPaytmSdk(edtOrderid.getText().toString());
        } else {
            Toast.makeText(this, "Pay option is null", Toast.LENGTH_LONG).show();
        }
    }

    // adding volley request in queue for api call
    private void executeRequest(Request request) {
        request.setRetryPolicy(new DefaultRetryPolicy(DefaultRetryPolicy.DEFAULT_TIMEOUT_MS, SDKConstants.RETRY_TIMES, DefaultRetryPolicy.DEFAULT_BACKOFF_MULT));
        VolleyRequestQueue.getInstance(this).addToRequestQueue(request);
    }

    //creating request json for fetch pay option mainly using transaction token
    public static String createJsonForFetchAPI(String instrumentTypeValue, String token) {

        Map<String, String> headers = new HashMap<>();
        headers.put(SDKConstants.CONTENT_TYPE, SDKConstants.APPLICATION_JSON);
        JSONObject fetchPayJsonObject = new JSONObject();
        JSONObject headJsonObject = new JSONObject();
        JSONObject bodyJsonObject = new JSONObject();

        try {
            headJsonObject.put(SDKConstants.KEY_REQUEST_TIMESTAMP, System.currentTimeMillis() + "");
            headJsonObject.put(SDKConstants.TOKEN, token);
            headJsonObject.put(SDKConstants.VERSION, BuildConfig.VERSION_NAME);
            headJsonObject.put("channelId", SDKConstants.WAP);
            bodyJsonObject.put("sdkVersion", "Android_" + "1.0");

            JSONArray instrumentType = new JSONArray();
            instrumentType.put(instrumentTypeValue);

            fetchPayJsonObject.put(SDKConstants.HEAD, headJsonObject);
            fetchPayJsonObject.put(SDKConstants.BODY, bodyJsonObject);

        } catch (JSONException e) {
        }
        return fetchPayJsonObject.toString();
    }


    @Override
    public void onTransactionResponse(TransactionInfo transactionInfo) {

    }

    @Override
    public void networkError() {

    }

    @Override
    public void onBackPressedCancelTransaction() {

    }

    @Override
    public void onGenericError(int i, String s) {

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 102) {
            if (resultCode == RESULT_OK) {
                Toast.makeText(MainActivity.this, "SMS permission granted", Toast.LENGTH_SHORT).show();
            }
        }
    }
}