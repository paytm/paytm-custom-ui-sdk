package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;
import net.one97.paytm.nativesdk.common.model.MerchantDetails;

import java.util.ArrayList;

/**
 * Created by jassikaushik on 13/12/17.
 */


public class Body implements BaseDataModel {
    private MerchantPayOption addMoneyPayOption;

    private MerchantPayOption merchantPayOption;

    private MerchantDetails merchantDetails;

    private String paymentFlow;

    private ResultInfo resultInfo;

    private Boolean walletOnly;

    private BinDetail binDetail;

    private Boolean isEmiAvailable;

    private String[] authModes;

    private HasLowSuccess hasLowSuccessRate;

    private String iconUrl;

    private PromoCodeData promoCodeData;

    private ArrayList<RiskConvenienceFeeItem> riskConvenienceFee;

    private String oneClickMaxAmount;

    private boolean oneClickSupported;

    private boolean nativeJsonRequestSupported;

    private boolean isHybridDisabled;

    private String iconBaseUrl;

    public boolean isNativeJsonRequestSupported() {
        return nativeJsonRequestSupported;
    }

    public void setNativeJsonRequestSupported(boolean nativeJsonRequestSupported) {
        this.nativeJsonRequestSupported = nativeJsonRequestSupported;
    }

    private ArrayList<PaymentOffer> paymentOffers;

    public MerchantPayOption getAddMoneyPayOption() {
        return addMoneyPayOption;
    }

    public void setAddMoneyPayOption(MerchantPayOption addMoneyPayOption) {
        this.addMoneyPayOption = addMoneyPayOption;
    }

    public MerchantPayOption getMerchantPayOption() {
        return merchantPayOption;
    }

    public void setMerchantPayOption(MerchantPayOption merchantPayOption) {
        this.merchantPayOption = merchantPayOption;
    }

    public String getPaymentFlow() {
        return paymentFlow;
    }

    public void setPaymentFlow(String paymentFlow) {
        this.paymentFlow = paymentFlow;
    }

    public ResultInfo getResultInfo() {
        return resultInfo;
    }

    public void setResultInfo(ResultInfo resultInfo) {
        this.resultInfo = resultInfo;
    }

    public ArrayList<RiskConvenienceFeeItem> getRiskConvenienceFee() {
        return riskConvenienceFee;
    }

    public void setRiskConvenienceFee(ArrayList<RiskConvenienceFeeItem> riskConvenienceFee) {
        this.riskConvenienceFee = riskConvenienceFee;
    }

    @Override
    public String toString() {
        return "ClassPojo [addMoneyPayOption = " + addMoneyPayOption + ", merchantPayOption = " + merchantPayOption + ", paymentFlow = " + paymentFlow + ", resultInfo = " + resultInfo + "]";
    }

    public BinDetail getBinDetail() {
        return binDetail;
    }

    public void setBinDetail(BinDetail binDetail) {
        this.binDetail = binDetail;
    }

    public HasLowSuccess getHasLowSuccessRate() {
        return hasLowSuccessRate;
    }

    public void setHasLowSuccessRate(HasLowSuccess hasLowSuccessRate) {
        this.hasLowSuccessRate = hasLowSuccessRate;
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

    public MerchantDetails getMerchantDetails() {
        return merchantDetails;
    }

    public void setMerchantDetails(MerchantDetails merchantDetails) {
        this.merchantDetails = merchantDetails;
    }

    public PromoCodeData getPromoCodeData() {
        return promoCodeData;
    }

    public void setPromoCodeData(PromoCodeData promoCodeData) {
        this.promoCodeData = promoCodeData;
    }

    public ArrayList<PaymentOffer> getPaymentOffers() {
        return paymentOffers;
    }

    public void setPaymentOffers(ArrayList<PaymentOffer> paymentOffers) {
        this.paymentOffers = paymentOffers;
    }

    public Boolean getEmiAvailable() {
        return isEmiAvailable;
    }

    public void setEmiAvailable(Boolean emiAvailable) {
        isEmiAvailable = emiAvailable;
    }

    public String getOneClickMaxAmount() {
        return oneClickMaxAmount;
    }

    public void setOneClickMaxAmount(String oneClickMaxAmount){
        this.oneClickMaxAmount = oneClickMaxAmount;
    }

    public boolean isOneClickSupported() {
        return oneClickSupported;
    }

    public void setOneClickSupported(boolean oneClickSupported){
        this.oneClickSupported = oneClickSupported;
    }

    public boolean isHybridDisabled() {
        return isHybridDisabled;
    }

    public boolean isWalletOnly() {
        return walletOnly != null && walletOnly;
    }

    public String getIconBaseUrl() {
        return iconBaseUrl;
    }

    public void setIconBaseUrl(String iconBaseUrl) {
        this.iconBaseUrl = iconBaseUrl;
    }
}

