package com.paytm.merchantsampleapp.model


data class FetchCardIndexRequest(val head: Head, val body: Body) {

    data class Head(
        val version: String = "v1",
        val timeStamp: String,
        val requestId: String,
        val channnelId: String = "APP",
        val tokenType: String = "CHECKSUM",
        val token: String = "76jplzWQJlWe2ITHZR/ebwSFOdgXZFr4rEL8+7+jS5+ke1kzOFPEwllYZ7ne57KUXo9utGcCWy6iW9YIcHcX24Elu40S8dH+3gR49Zr8uL0="
    )

    data class Body(val cardNumber: String, val cardExpiry: String)
}


data class FetchCardIndexResponse(val head: Head?, val body: Body?) {
    data class Head(
        val version: String = "v1", val responseTimestamp: String
    )

    data class Body(val cardIndexNumber: String?, val resultInfo: ResultInfo?)

}
