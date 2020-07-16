
package com.paytm.merchantsampleapp.model;


import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;
import java.util.HashMap;

public class MerchantPayMethod implements BaseDataModel {

    private String payMethod;
    private String displayName;
    private ArrayList<PayChannelOption> payChannelOptions = null;
    private IsDisabled isDisabled;
    private HashMap<String, Object> additionalProperties = new HashMap<String, Object>();

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public ArrayList<PayChannelOption> getPayChannelOptions() {
        return payChannelOptions;
    }

    public void setPayChannelOptions(ArrayList<PayChannelOption> payChannelOptions) {
        this.payChannelOptions = payChannelOptions;
    }

    public IsDisabled getIsDisabled() {
        return isDisabled;
    }

    public void setIsDisabled(IsDisabled isDisabled) {
        this.isDisabled = isDisabled;
    }


    public HashMap<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

}
