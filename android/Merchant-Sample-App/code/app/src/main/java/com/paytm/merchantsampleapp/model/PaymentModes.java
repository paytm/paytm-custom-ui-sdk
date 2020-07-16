package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;

/**
 * Created by jassikaushik on 10/01/18.
 */

public class PaymentModes implements BaseDataModel {
    private IsDisabled isDisabled;

    private String paymentMode;

    private ArrayList<PayChannelOptions> payChannelOptions;

    private String displayName;

    private int sortingWeight = 0;

    private String priority;

    private boolean onboarding;

    private boolean isHybridDisabled;

    private boolean isEmiHybridDisabled;

    private boolean oneClickSupported;

    private PaymentOfferDetails paymentOfferDetails;

    private ApplyPromoResponse.PaymentOffer paymentOffer;

    private ApplyPromoResponse.PaymentOffer hybridPaymentOffer;

    public IsDisabled getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(IsDisabled isDisabled) {
        this.isDisabled = isDisabled;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public ArrayList<PayChannelOptions> getPayChannelOptions() {
        return payChannelOptions;
    }

    public void setPayChannelOptions(ArrayList<PayChannelOptions> payChannelOptions) {
        this.payChannelOptions = payChannelOptions;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setSortingWeight(int sortingWeight) {
        this.sortingWeight = sortingWeight;
    }

    public int getSortingWeight() {
        return sortingWeight;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public void setOnboarding(boolean onboarding) {
        this.onboarding = onboarding;
    }

    public boolean getOnboarding() {
        return onboarding;
    }

    @Override
    public String toString() {
        return "ClassPojo [isDisabled = " + isDisabled + ", paymentMode = " + paymentMode + ", payChannelOptions = " + payChannelOptions + ", displayName = " + displayName + "]";
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public boolean isOnboarding() {
        return onboarding;
    }

    public PaymentOfferDetails getPaymentOfferDetails() {
        return paymentOfferDetails;
    }

    public void setPaymentOfferDetails(PaymentOfferDetails paymentOfferDetails) {
        this.paymentOfferDetails = paymentOfferDetails;
    }

    public void setPaymentOffer(ApplyPromoResponse.PaymentOffer paymentOffer) {
        this.paymentOffer = paymentOffer;
    }

    public void setHybridPaymentOffer(ApplyPromoResponse.PaymentOffer hybridPaymentOffer) {
        this.hybridPaymentOffer = hybridPaymentOffer;
    }

    public ApplyPromoResponse.PaymentOffer getPaymentOffer() {
        return paymentOffer;
    }

    public ApplyPromoResponse.PaymentOffer getHybridPaymentOffer() {
        return hybridPaymentOffer;
    }

    public boolean isOneClickSupported() {
        return oneClickSupported;
    }

    public boolean isHybridDisabled() {
        return isHybridDisabled;
    }

    public boolean isEmiHybridDisabled() {
        return isEmiHybridDisabled;
    }

}


