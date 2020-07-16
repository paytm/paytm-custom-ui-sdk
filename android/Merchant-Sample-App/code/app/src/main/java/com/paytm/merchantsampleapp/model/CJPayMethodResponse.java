package com.paytm.merchantsampleapp.model;

import androidx.annotation.Keep;


import net.one97.paytm.nativesdk.common.model.BaseDataModel;


/**
 * Created by jassi.kaushik on 08/09/17.
 */

@Keep
public class CJPayMethodResponse implements BaseDataModel {

    private Body body;

    private Head head;

    public Body getBody() {
        return body;
    }

    public void setBody(Body body) {
        this.body = body;
    }

    public Head getHead() {
        return head;
    }

    public void setHead(Head head) {
        this.head = head;
    }

    @Override
    public String toString() {
        return "ClassPojo [body = " + body + ", head = " + head + "]";
    }
}




