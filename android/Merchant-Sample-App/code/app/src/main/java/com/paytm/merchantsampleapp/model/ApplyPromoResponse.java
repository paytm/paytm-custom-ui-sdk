package com.paytm.merchantsampleapp.model;

import android.text.TextUtils;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;

public class ApplyPromoResponse implements net.one97.paytm.nativesdk.common.model.BaseDataModel {

    private Head head;

    private Body body;


    public Head getHead() {
        return head;
    }

    public void setHead(Head head) {
        this.head = head;
    }

    public Body getBody() {
        return body;
    }

    public void setBody(Body body) {
        this.body = body;
    }

    public static class Head implements net.one97.paytm.nativesdk.common.model.BaseDataModel {
        private String requestId;
        private String responseTimestamp;
        private String version;

        public String getRequestId() {
            return requestId;
        }

        public void setRequestId(String requestId) {
            this.requestId = requestId;
        }

        public String getResponseTimestamp() {
            return responseTimestamp;
        }

        public void setResponseTimestamp(String responseTimestamp) {
            this.responseTimestamp = responseTimestamp;
        }

        public String getVersion() {
            return version;
        }

        public void setVersion(String version) {
            this.version = version;
        }
    }


    public static class Body implements net.one97.paytm.nativesdk.common.model.BaseDataModel {

        private ResultInfo resultInfo;

        private PaymentOffer paymentOffer;


        public ResultInfo getResultInfo() {
            return resultInfo;
        }

        public void setResultInfo(ResultInfo resultInfo) {
            this.resultInfo = resultInfo;
        }

        public PaymentOffer getPaymentOffer() {
            return paymentOffer;
        }

        public void setPaymentOffer(PaymentOffer paymentOffer) {
            this.paymentOffer = paymentOffer;
        }
    }


    public static class PaymentOffer implements net.one97.paytm.nativesdk.common.model.BaseDataModel {

        private String totalInstantDiscount;

        private String totalCashbackAmount;

        private ArrayList<OfferBreakup> offerBreakup;

        public String getTotalInstantDiscount() {
            return totalInstantDiscount;
        }

        public void setTotalInstantDiscount(String totalInstantDiscount) {
            this.totalInstantDiscount = totalInstantDiscount;
        }

        public String getTotalCashbackAmount() {
            return totalCashbackAmount;
        }

        public void setTotalCashbackAmount(String totalCashbackAmount) {
            this.totalCashbackAmount = totalCashbackAmount;
        }

        public ArrayList<OfferBreakup> getOfferBreakup() {
            return offerBreakup;
        }

        public void setOfferBreakup(ArrayList<OfferBreakup> offerBreakup) {
            this.offerBreakup = offerBreakup;
        }
    }

    public static class OfferBreakup implements BaseDataModel {
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

        public String getPromotext() {
            return promotext;
        }

        public void setPromotext(String promotext) {
            this.promotext = promotext;
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

        public void setPromoVisibility(String promoVisibility) {
            this.promoVisibility = promoVisibility;
        }

        public String getPromoVisibility() {
            return promoVisibility;
        }

        public boolean isPromoVisible(){
            return !TextUtils.isEmpty(promoVisibility) && "true".equalsIgnoreCase(promoVisibility);
        }
    }
}
