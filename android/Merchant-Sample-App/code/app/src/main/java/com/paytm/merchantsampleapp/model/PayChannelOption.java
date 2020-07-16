package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by gaurav4.jain on 05/09/17.
 */

public class PayChannelOption implements BaseDataModel {


    String payMethod;
    boolean isSelected;

    private BalanceInfo balanceInfo;

    public BalanceInfo getBalanceInfo() {
        return balanceInfo;
    }

    public void setBalanceInfo(BalanceInfo balanceInfo) {
        this.balanceInfo = balanceInfo;
    }

    public PayChannelOption(String payMethod, String payChannelOption, String instId, String instName, String iconUrl, IsDisabled isDisabled, HasLowSuccess hasLowSuccess) {
        this.payMethod = payMethod;
        this.payChannelOption = payChannelOption;
        this.instId = instId;
        this.instName = instName;
        this.iconUrl = iconUrl;
        this.isDisabled = isDisabled;
        this.hasLowSuccess = hasLowSuccess;

    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public String getPayChannelOption() {
        return payChannelOption;
    }

    public void setPayChannelOption(String payChannelOption) {
        this.payChannelOption = payChannelOption;
    }

    public String getInstId() {
        return instId;
    }


    public void setInstId(String instId) {
        this.instId = instId;
    }

    public String getInstName() {
        return instName;
    }

    public void setInstName(String instName) {
        this.instName = instName;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    String payChannelOption;
    String instId;
    String instName;
    String iconUrl;
    IsDisabled isDisabled;
    HasLowSuccess hasLowSuccess;

    public IsDisabled getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(IsDisabled isDisabled) {
        this.isDisabled = isDisabled;
    }

    public HasLowSuccess getHasLowSuccess() {
        return hasLowSuccess;
    }

    public void setHasLowSuccess(HasLowSuccess hasLowSuccess) {
        this.hasLowSuccess = hasLowSuccess;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }


}
