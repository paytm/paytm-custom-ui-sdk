package com.paytm.merchantsampleapp.model;

import android.os.Build;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by jassikaushik on 10/01/18.
 */


public class SavedInstruments implements BaseDataModel {

    private String selectedAuthMode;

    private IsDisabled isDisabled;

    private String channelName;

    private EmiDetails emiDetails;

    private String channelCode;

    private String issuingBankCode;

    private String issuingBank;

    private String iconUrl;

    private String[] authModes;

    private HasLowSuccess hasLowSuccess;

    private CardDetails cardDetails;

    private boolean isEmiAvailable;

    private boolean isHybridDisabled;

    private boolean isEmiHybridDisabled;

    private boolean oneClickSupported;

    private String subventionType;

    private boolean isCardCoft;

    private boolean isEligibleForCoft;

    private boolean isCoftPaymentSupported;

    @SerializedName("priority")
    @Expose
    private String priority;

    @SerializedName("minAmount")
    @Expose
    private MinAmount minAmount;

    @SerializedName("maxAmount")
    @Expose
    private MinAmount maxAmount;

    private PaymentOfferDetails paymentOfferDetails;

    private String displayName;

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public IsDisabled getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(IsDisabled isDisabled) {
        this.isDisabled = isDisabled;
    }

    public String getChannelName() {
        return channelName;
    }

    public void setChannelName(String channelName) {
        this.channelName = channelName;
    }

    public EmiDetails getEmiDetails() {
        return emiDetails;
    }

    public void setEmiDetails(EmiDetails emiDetails) {
        this.emiDetails = emiDetails;
    }

    public String getChannelCode() {
        return channelCode;
    }

    public void setChannelCode(String channelCode) {
        this.channelCode = channelCode;
    }

    public String getIssuingBank() {
        return issuingBank;
    }

    public void setIssuingBank(String issuingBank) {
        this.issuingBank = issuingBank;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public String[] getAuthModes() {
        return authModes;
    }

    public void setAuthModes(String[] authModes) {
        this.authModes = authModes;
    }

    public HasLowSuccess getHasLowSuccess() {
        return hasLowSuccess;
    }

    public void setHasLowSuccess(HasLowSuccess hasLowSuccess) {
        this.hasLowSuccess = hasLowSuccess;
    }

    public CardDetails getCardDetails() {
        return cardDetails;
    }

    public void setCardDetails(CardDetails cardDetails) {
        this.cardDetails = cardDetails;
    }

    @Override
    public String toString() {
        return "ClassPojo [isDisabled = " + isDisabled + ", channelName = " + channelName + ", emiDetails = " + emiDetails + ", channelCode = " + channelCode + ", issuingBank = " + issuingBank + ", iconUrl = " + iconUrl + ", authModes = " + authModes + ", hasLowSuccess = " + hasLowSuccess + ", cardDetails = " + cardDetails + "]";
    }

    public String getSelectedAuthMode() {
        return selectedAuthMode;
    }

    public void setSelectedAuthMode(String selectedAuthMode) {
        this.selectedAuthMode = selectedAuthMode;
    }

    public String getIssuingBankCode() {
        return issuingBankCode;
    }

    public boolean isEmiAvailable() {
        return isEmiAvailable;
    }

    public void setEmiAvailable(boolean emiAvailable) {
        isEmiAvailable = emiAvailable;
    }

    public void setIssuingBankCode(String issuingBankCode) {
        this.issuingBankCode = issuingBankCode;
    }

    public PaymentOfferDetails getPaymentOfferDetails() {
        return paymentOfferDetails;
    }

    public void setPaymentOfferDetails(PaymentOfferDetails paymentOfferDetails) {
        this.paymentOfferDetails = paymentOfferDetails;
    }

    public MinAmount getMinAmount() {
        return minAmount;
    }

    public MinAmount getMaxAmount() {
        return maxAmount;
    }

    public String getSubventionType() {
        return subventionType;
    }

    public void setSubventionType(String subventionType) {
        this.subventionType = subventionType;
    }

    public boolean isOneClickSupported() {
        return Build.VERSION.SDK_INT >= 19 && oneClickSupported;
    }
    public boolean isHybridDisabled() {
        return isHybridDisabled;
    }

    public boolean isEmiHybridDisabled() {
        return isEmiHybridDisabled;
    }

    public String getPriority() {
        return priority;
    }

    public boolean isCardCoFT() {
        return isCardCoft;
    }

    public boolean isEligibleForCoFT() {
        return isEligibleForCoft;
    }

    public boolean isCoFTPaymentSupported() {
        return isCoftPaymentSupported;
    }
}


