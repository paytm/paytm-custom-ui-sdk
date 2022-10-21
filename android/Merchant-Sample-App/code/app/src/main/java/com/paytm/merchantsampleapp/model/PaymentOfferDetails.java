package com.paytm.merchantsampleapp.model;

import android.text.TextUtils;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

public class PaymentOfferDetails implements BaseDataModel {

    private String promocodeApplied;

    private String promotext;

    private String instantDiscount;

    private String cashbackAmount;

    private String payMethod;

    private String promoVisibility;

    public String getPromocodeApplied() {
        return promocodeApplied;
    }

    public void setPromocodeApplied(String promocodeApplied) {
        this.promocodeApplied = promocodeApplied;
    }

    public String getPromoText() {
        return promotext;
    }

    public void setPromoText(String promoText) {
        this.promotext = promoText;
    }

    public String getInstantDiscount() {
        return instantDiscount;
    }

    public void setInstantDiscount(String instantDiscount) {
        this.instantDiscount = instantDiscount;
    }

    public String getCashbackAmount() {
        return cashbackAmount;
    }

    public void setCashbackAmount(String cashbackAmount) {
        this.cashbackAmount = cashbackAmount;
    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public String getPromoVisibility() {
        return promoVisibility;
    }

    public void setPromoVisibility(String promoVisibility) {
        this.promoVisibility = promoVisibility;
    }

    private boolean isPromoVisible(){
        return !TextUtils.isEmpty(promoVisibility) && "true".equalsIgnoreCase(promoVisibility);
    }
}
