package com.paytm.merchantsampleapp

import android.app.Application
import net.one97.paytm.nativesdk.PaytmSDK

class SampleApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        PaytmSDK.init(this)
    }
}