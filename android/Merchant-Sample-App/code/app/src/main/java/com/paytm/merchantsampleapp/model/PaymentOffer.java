package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

public class PaymentOffer implements BaseDataModel {

    private String promoCode;

    private Offer offer;

    private String termsUrl;

    private String termTitle;

    private String validFrom;

    private String validUpto;

    private String isPromoVisible;

    public String getPromoCode() {
        return promoCode;
    }

    public void setPromoCode(String promoCode) {
        this.promoCode = promoCode;
    }

    public Offer getOffer() {
        return offer;
    }

    public void setOffer(Offer offer) {
        this.offer = offer;
    }

    public String getTermsUrl() {
        return termsUrl;
    }

    public void setTermsUrl(String termsUrl) {
        this.termsUrl = termsUrl;
    }

    public String getTermTitle() {
        return termTitle;
    }

    public void setTermTitle(String termTitle) {
        this.termTitle = termTitle;
    }

    public String getValidFrom() {
        return validFrom;
    }

    public void setValidFrom(String validFrom) {
        this.validFrom = validFrom;
    }

    public String getValidUpto() {
        return validUpto;
    }

    public void setValidUpto(String validUpto) {
        this.validUpto = validUpto;
    }

    public String getIsPromoVisible() {
        return isPromoVisible;
    }

    public void setIsPromoVisible(String isPromoVisible) {
        this.isPromoVisible = isPromoVisible;
    }


    public static class Offer{

        private String title;
        private String text;
        private String icon;


        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }

        public String getIcon() {
            return icon;
        }

        public void setIcon(String icon) {
            this.icon = icon;
        }
    }
}
