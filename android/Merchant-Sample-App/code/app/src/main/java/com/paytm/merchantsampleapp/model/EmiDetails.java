package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;

/**
 * Created by jassikaushik on 11/01/18.
 */

public class EmiDetails implements BaseDataModel {
    private IsDisabled isDisabled;

    private String channelName;

    private ArrayList<EmiChannelInfos> emiChannelInfos;

    private String channelCode;

    private String iconUrl;

    private String emiType;

    private HasLowSuccess hasLowSuccess;

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

    public ArrayList<EmiChannelInfos> getEmiChannelInfos() {
        return emiChannelInfos;
    }

    public void setEmiChannelInfos(ArrayList<EmiChannelInfos> emiChannelInfos) {
        this.emiChannelInfos = emiChannelInfos;
    }

    public String getEmiType() {
        return emiType;
    }

    public void setEmiType(String emiType) {
        this.emiType = emiType;
    }

    public String getChannelCode() {
        return channelCode;
    }

    public void setChannelCode(String channelCode) {
        this.channelCode = channelCode;
    }

    public String getIconUrl() {
        return iconUrl;
    }

    public void setIconUrl(String iconUrl) {
        this.iconUrl = iconUrl;
    }

    public HasLowSuccess getHasLowSuccess() {
        return hasLowSuccess;
    }

    public void setHasLowSuccess(HasLowSuccess hasLowSuccess) {
        this.hasLowSuccess = hasLowSuccess;
    }

    @Override
    public String toString() {
        return "ClassPojo [isDisabled = " + isDisabled + ", channelName = " + channelName + ", emiChannelInfos = " + emiChannelInfos + ", channelCode = " + channelCode + ", iconUrl = " + iconUrl + ", hasLowSuccess = " + hasLowSuccess + "]";
    }
}
