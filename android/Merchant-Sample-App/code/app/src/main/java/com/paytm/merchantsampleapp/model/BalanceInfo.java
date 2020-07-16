
package com.paytm.merchantsampleapp.model;


import net.one97.paytm.nativesdk.common.model.BaseDataModel;

import java.util.ArrayList;

public class BalanceInfo implements BaseDataModel {

    private AccountBalance accountBalance;

    private String payerAccountExists;

    private ArrayList<SubWalletDetail> subWalletDetails;

    public AccountBalance getAccountBalance ()
    {
        return accountBalance;
    }

    public void setAccountBalance (AccountBalance accountBalance) {
        this.accountBalance = accountBalance;
    }

    public String getPayerAccountExists ()
    {
        return payerAccountExists;
    }

    public void setPayerAccountExists (String payerAccountExists) {
        this.payerAccountExists = payerAccountExists;
    }

    public ArrayList<SubWalletDetail> getSubWalletDetails() {
        return subWalletDetails;
    }

    public void setSubWalletDetails(ArrayList<SubWalletDetail> subWalletDetails) {
        this.subWalletDetails = subWalletDetails;
    }

    @Override
    public String toString() {
        return "ClassPojo [accountBalance = "+accountBalance+", payerAccountExists = "+payerAccountExists+"]";
    }
}
