# Android - Custom UI SDK
* More Details: **https://developer.paytm.com/docs/custom-ui-sdk/#android**

1. Add dependencies
2. Set PaytmSDK.init(context) in onCreate of Application class and attach it through manifest.
3. Check if paytm is installed using `PaymentsUtilRepository.isPaytmAppInstalled` if auth code is fetched, pass it to your server and get SSO token.
4. Pass sso token of Paytm user while calling Initiate transaction API to access all methods else you can't use wallet, UPI push and saved cards methods(Refer flow chart on developer page of Paytm for auth code feature)
5. Then you can fetch user’s saved instruments from server with transaction token received in initiate transaction api.
6. Implement the interface `PaytmSDKCallbackListener` for transaction response.
7. As a merchant you must have flowing params
  - Merchant Id
  - Order ID
  - Amount
  - transaction token
    Using above params you create PaytmSDK instance.
8. User method provided for transaction and basic detail using PaytmSDK