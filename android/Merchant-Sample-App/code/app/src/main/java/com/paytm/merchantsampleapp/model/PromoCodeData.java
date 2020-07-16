package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

public class PromoCodeData implements BaseDataModel {

    private String promoCode;
    private String promoMsg;
    private String promoCodeValid;
    private String promoCodeTypeName;
    private String promoCodeMsg;

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public String getPromoMsg() {
        return promoMsg;
    }

    public void setPromoMsg(String promoMsg) {
        this.promoMsg = promoMsg;
    }

    public String getPromoCodeValid() {
        return promoCodeValid;
    }

    public void setPromoCodeValid(String promoCodeValid) {
        this.promoCodeValid = promoCodeValid;
    }

    public String getPromoCodeTypeName() {
        return promoCodeTypeName;
    }

    public void setPromoCodeTypeName(String promoCodeTypeName) {
        this.promoCodeTypeName = promoCodeTypeName;
    }

    public String getPromoCodeMsg() {
        return promoCodeMsg;
    }

    public void setPromoCodeMsg(String promoCodeMsg) {
        this.promoCodeMsg = promoCodeMsg;
    }


}
