
package com.paytm.merchantsampleapp.model;


import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.HashMap;
import java.util.Map;

public class IsDisabled implements BaseDataModel {


    private boolean merchantAccept;

    private boolean status;

    private boolean userAccountExist;

    private String msg;


    private Map<String, Object> additionalProperties = new HashMap<String, Object>();

    public Map<String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    public void setAdditionalProperty(String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    public boolean getMerchantAccept() {
        return merchantAccept;
    }

    public void setMerchantAccept(boolean merchantAccept) {
        this.merchantAccept = merchantAccept;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public boolean getUserAccountExist() {
        return userAccountExist;
    }

    public void setUserAccountExist(boolean userAccountExist) {
        this.userAccountExist = userAccountExist;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    @Override
    public String toString() {
        return "ClassPojo [merchantAccept = " + merchantAccept + ", status = " + status + ", userAccountExist = " + userAccountExist + ", msg = " + msg + "]";
    }
}


