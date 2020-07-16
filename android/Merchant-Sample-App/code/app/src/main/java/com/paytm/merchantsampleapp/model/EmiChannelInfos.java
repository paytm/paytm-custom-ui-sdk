package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by jassikaushik on 29/01/18.
 */


public class EmiChannelInfos implements BaseDataModel {
    private MinAmount minAmount;

    private MaxAmount maxAmount;

    private String ofMonths;

    private String planId;

    private String interestRate;

    public MinAmount getMinAmount() {
        return minAmount;
    }

    public void setMinAmount(MinAmount minAmount) {
        this.minAmount = minAmount;
    }

    public MaxAmount getMaxAmount() {
        return maxAmount;
    }

    public void setMaxAmount(MaxAmount maxAmount) {
        this.maxAmount = maxAmount;
    }

    public String getOfMonths() {
        return ofMonths;
    }

    public void setOfMonths(String ofMonths) {
        this.ofMonths = ofMonths;
    }

    public String getPlanId() {
        return planId;
    }

    public void setPlanId(String planId) {
        this.planId = planId;
    }

    public String getInterestRate() {
        return interestRate;
    }

    public void setInterestRate(String interestRate) {
        this.interestRate = interestRate;
    }

    @Override
    public String toString() {
        return "ClassPojo [minAmount = " + minAmount + ", maxAmount = " + maxAmount + ", ofMonths = " + ofMonths + ", planId = " + planId + ", interestRate = " + interestRate + "]";
    }
}


