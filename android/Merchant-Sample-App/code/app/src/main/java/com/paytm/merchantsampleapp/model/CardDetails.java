package com.paytm.merchantsampleapp.model;

import net.one97.paytm.nativesdk.common.model.BaseDataModel;

/**
 * Created by jassikaushik on 10/01/18.
 */

public class CardDetails implements BaseDataModel {
    private String cardId;

    private String status;

    private String expiryDate;

    private String lastFourDigit;

    private String cardType;

    private String firstSixDigit;

    private String cardHash;

    private String firstEightDigit;

    private String bin;

    public String getBin() {
        return bin;
    }

    public void setBin(String bin) {
        this.bin = bin;
    }

    public String getCardId() {
        return cardId;
    }

    public void setCardId(String cardId) {
        this.cardId = cardId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getLastFourDigit() {
        return lastFourDigit;
    }

    public void setLastFourDigit(String lastFourDigit) {
        this.lastFourDigit = lastFourDigit;
    }

    public String getCardType() {
        return cardType;
    }

    public void setCardType(String cardType) {
        this.cardType = cardType;
    }

    public String getFirstSixDigit() {
        return firstSixDigit;
    }

    public void setFirstSixDigit(String firstSixDigit) {
        this.firstSixDigit = firstSixDigit;
    }

    public String getCardHash() {
        return cardHash;
    }

    public void setCardHash(String cardHash) {
        this.cardHash = cardHash;
    }

    public String getFirstEightDigit() {
        return firstEightDigit;
    }

    public void setFirstEightDigit(String firstEightDigit) {
        this.firstEightDigit = firstEightDigit;
    }

    @Override
    public String toString() {
        return "ClassPojo [cardId = " + cardId + ", status = " + status + ", expiryDate = " + expiryDate + ", lastFourDigit = " + lastFourDigit + ", cardType = " + cardType + ", firstSixDigit = " + firstSixDigit + "]";
    }
}


