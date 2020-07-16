package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

public class RiskConvenienceFeeItem implements BaseDataModel {
    private String payMethod;
    private String feePercent;
    private String reason;

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public String getFeePercent() {
        return feePercent;
    }

    public void setFeePercent(String feePercent) {
        this.feePercent = feePercent;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }
}
