package com.paytm.merchantsampleapp.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by prince.batra
 * on 16/01/18
 */


public class BinDetail implements BaseDataModel {
    @SerializedName("bin")
    @Expose
    private String bin;
    @SerializedName("issuingBank")
    @Expose
    private String issuingBank;
    @SerializedName("issuingBankCode")
    @Expose
    private String issuingBankCode;
    @SerializedName("paymentMode")
    @Expose
    private String paymentMode;
    @SerializedName("channelName")
    @Expose
    private String channelName;
    @SerializedName("channelCode")
    @Expose
    private String channelCode;
    @SerializedName("isActive")
    @Expose
    private String isActive;

    @SerializedName("iconUrl")
    @Expose
    private String iconUrl;

    @SerializedName("cnMin")
    @Expose
    private String cardNumberMinLength;

    @SerializedName("cnMax")
    @Expose
    private String cardNumberMaxLength;

    @SerializedName("cvvR")
    @Expose
    private String cvvRequired;

    @SerializedName("cvvL")
    @Expose
    private String cvvLength;

    @SerializedName("expR")
    @Expose
    private String expiryRequired;

    private String isIndian;

    @SerializedName("oneClickSupported")
    @Expose
    private boolean oneClickSupported;

    private boolean isEligibleForCoft;

    public String getIssuingBankCode() {
        return issuingBankCode;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public String getChannelCode() {
        return channelCode;
    }

    public boolean isOneClickSupported() { return oneClickSupported; }

    public boolean isEligibleForCoFT() {
        return isEligibleForCoft;
    }
}
