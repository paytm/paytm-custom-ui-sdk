
package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.HashMap;
import java.util.Map;

public class ResultInfo implements BaseDataModel {

    private String resultStatus;
    private String resultCode;
    private String resultMsg;
    private final Map<String, Object> additionalProperties = new HashMap<String, Object>();


    public String getResultMsg() {
        return resultMsg;
    }

}
