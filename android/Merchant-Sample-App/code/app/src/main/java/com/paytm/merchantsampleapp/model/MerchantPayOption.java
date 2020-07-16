package com.paytm.merchantsampleapp.model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;

/**
 * Created by jassikaushik on 10/01/18.
 */

public class MerchantPayOption implements BaseDataModel {
    private ArrayList<SavedInstruments> savedInstruments;

    private ArrayList<PaymentModes> paymentModes;

    public ArrayList<SavedInstruments> getSavedInstruments() {
        return savedInstruments;
    }

    @SerializedName("upiProfile")
    @Expose
    private UpiProfile upiProfile;

    public void setSavedInstruments(ArrayList<SavedInstruments> savedInstruments) {
        this.savedInstruments = savedInstruments;
    }

    public ArrayList<PaymentModes> getPaymentModes() {
        return paymentModes;
    }

    public void setPaymentModes(ArrayList<PaymentModes> paymentModes) {
        this.paymentModes = paymentModes;
    }

    @Override
    public String toString() {
        return "ClassPojo [savedInstruments = " + savedInstruments + ", paymentModes = " + paymentModes + "]";
    }

    public UpiProfile getUpiProfile() {
        return upiProfile;
    }

    public void setUpiProfile(UpiProfile upiProfile) {
        this.upiProfile = upiProfile;
    }
}

