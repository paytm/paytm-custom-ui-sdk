package com.paytm.merchantsampleapp.model;

import android.view.View;

import androidx.databinding.ObservableBoolean;
import androidx.databinding.ObservableField;
import androidx.databinding.ObservableInt;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by jassikaushik on 10/01/18.
 */

public class PayChannelOptions implements BaseDataModel {

    private IsDisabled isDisabled;

    private String channelName;

    private String channelCode;

    private String iconUrl;

    private String emiType;

    private HasLowSuccess hasLowSuccess;

    private BalanceInfo balanceInfo;

    private boolean isProceedVisible;

    private String mode;

    private ApplyPromoResponse.PaymentOffer paymentOffer;

    private ApplyPromoResponse.PaymentOffer hybridPaymentOffer;

    private String convFeeText;

    private String cachedPaymentIntent;

    private double convenienceFee;

    private boolean isConvFeeLoading;

    @SerializedName("templateId")
    @Expose
    private String templateId;

    @SerializedName("minAmount")
    @Expose
    private MinAmount minAmount;

    @SerializedName("maxAmount")
    @Expose
    private MinAmount maxAmount;

    public ObservableBoolean isGreenTickVisible = new ObservableBoolean(false);

    public ObservableBoolean bankSelectionProceedVisible = new ObservableBoolean(false);

    public ObservableInt lowSuccessVisibility = new ObservableInt(View.GONE);

    public ObservableField<String> amount = new ObservableField<>("");

    public boolean showCheckingOffer = false;


    public IsDisabled getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(IsDisabled isDisabled) {
        this.isDisabled = isDisabled;
    }

    public String getEmiType() {
        return emiType;
    }

    public void setEmiType(String emiType) {
        this.emiType = emiType;
    }



    public String getChannelName() {
        return channelName;
    }

    public void setChannelName(String channelName) {
        this.channelName = channelName;
    }

    public boolean isConvFeeLoading() {
        return isConvFeeLoading;
    }

    public void setConvFeeLoading(boolean convFeeLoading) {
        isConvFeeLoading = convFeeLoading;
    }

    public String getMode() {
        return mode;
    }

    public void setMode(String mode) {
        this.mode = mode;
    }

    public String getChannelCode() {
        return channelCode;
    }

    public void setChannelCode(String channelCode) {
        this.channelCode = channelCode;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public HasLowSuccess getHasLowSuccess() {
        return hasLowSuccess;
    }

    public void setHasLowSuccess(HasLowSuccess hasLowSuccess) {
        this.hasLowSuccess = hasLowSuccess;
    }

    public String getConvFeeText() {
        return convFeeText;
    }

    public void setConvFeeText(String convFeeText) {
        this.convFeeText = convFeeText;
    }

    public BalanceInfo getBalanceInfo() {
        return balanceInfo;
    }

    public void setBalanceInfo(BalanceInfo balanceInfo) {
        this.balanceInfo = balanceInfo;
    }

    public boolean isProceedVisible() {
        return isProceedVisible;
    }

    public void setProceedVisible(boolean proceedVisible) {
        isProceedVisible = proceedVisible;
    }

    public MinAmount getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(MinAmount minAmount) {
        this.minAmount = minAmount;
    }

    @Override
    public String toString() {
        return "ClassPojo [isDisabled = " + isDisabled + ", channelName = " + channelName + ", channelCode = " + channelCode + ", iconUrl = " + iconUrl + ", hasLowSuccess = " + hasLowSuccess + "]";
    }

    public MinAmount getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(MinAmount maxAmount) {
        this.maxAmount = maxAmount;
    }

    public ApplyPromoResponse.PaymentOffer getPaymentOffer() {
        return paymentOffer;
    }

    public void setPaymentOffer(ApplyPromoResponse.PaymentOffer paymentOffer) {
        this.paymentOffer = paymentOffer;
    }

    public void setHybridPaymentOffer(ApplyPromoResponse.PaymentOffer hybridPaymentOffer) {
        this.hybridPaymentOffer = hybridPaymentOffer;
    }

    public ApplyPromoResponse.PaymentOffer getHybridPaymentOffer() {
        return hybridPaymentOffer;
    }

    public double getConvenienceFee() {
        return convenienceFee;
    }

    public void setConvenienceFee(double convenienceFee) {
        this.convenienceFee = convenienceFee;
    }

    public String getCachedPaymentIntent() {
        return cachedPaymentIntent;
    }

    public void setCachedPaymentIntent(String cachedPaymentIntent) {
        this.cachedPaymentIntent = cachedPaymentIntent;
    }

    public String getTemplateId() {
        return templateId;
    }
}
