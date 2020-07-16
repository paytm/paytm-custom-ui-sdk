
package com.paytm.merchantsampleapp.model;


import net.one97.paytm.nativesdk.common.model.BaseDataModel;

public class AccountBalance implements BaseDataModel {

    private String currency;
    private String value;

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }


}
