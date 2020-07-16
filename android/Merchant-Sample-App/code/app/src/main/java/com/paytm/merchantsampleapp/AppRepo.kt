package com.paytm.merchantsampleapp

import com.paytm.merchantsampleapp.model.CJPayMethodResponse

object AppRepo {

    var cjPayMethodResponse: CJPayMethodResponse? = null

    fun storeInstrument(cjPayMethodResponse: CJPayMethodResponse) {
        this.cjPayMethodResponse = cjPayMethodResponse
    }


}