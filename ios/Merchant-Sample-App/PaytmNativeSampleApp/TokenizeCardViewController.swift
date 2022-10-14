//
//  TokenizeCardViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Aman Gupta on 29/12/21.
//  Copyright © 2021 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class TokenizeCardViewController: BaseViewController {
    var saveInstrument: String = "0"
    var apiCallMade = false
    var selectedModel: AINativeSavedCardParameterModel?
    var authenticationType: Authtype = .txnToken
    var selectedCardType : AINativePaymentModes = .debitCard
    var authModeType : AuthMode = .otp
    

    @IBOutlet weak var switchSaveInstrument: UISwitch!
    @IBOutlet weak var cardTokenTextField: UITextField!
    
    @IBOutlet weak var cardExpireDateTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    @IBOutlet weak var tAVVTextField: UITextField!
    @IBOutlet weak var panUniqueReferenceField: UITextField!
    @IBOutlet weak var cardSuffix: UITextField!

    @IBOutlet weak var authTypeSeg: UISegmentedControl!
    @IBOutlet weak var cardTypeSeg: UISegmentedControl!
    @IBOutlet weak var segIsAAuthToken: UISwitch!

    
    @IBAction func authTokenSeg(_ sender: Any) {
        if  self.segIsAAuthToken.isOn {
            authenticationType = .authToken
        } else {
            authenticationType = .txnToken
        }
    }
    
    @IBAction func cardTypeSeg(_ sender: Any) {
        if  self.cardTypeSeg.selectedSegmentIndex == 0 {
            selectedCardType = .debitCard
        } else {
            selectedCardType = .creditCard
        }
    }
    
    @IBAction func authTypeSeg(_ sender: Any) {
        if  self.authTypeSeg.selectedSegmentIndex == 0 {
            authModeType = .otp
        } else if self.authTypeSeg.selectedSegmentIndex == 1 {
            authModeType = .atm
        } else{
            authModeType = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardTokenTextField.delegate = self
    }
    
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
    }
    
    
    //MARK: action to get instruments from Local Vault.
    @IBAction func getLocalVaultData(_ sender: Any) {
        
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            let mid = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            var sso = ""
            if !(rootVC.ssoTokenTextField.text ?? "").isEmpty {
                 sso = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            }

            let checksum = (rootVC.checksumField.text == "") ? "" : rootVC.checksumField.text!
            let custId = (rootVC.custIdTextField.text == "") ? "CUST001" : rootVC.custIdTextField.text!

            self.appInvoke.getInstrumentFromLocalVault(custId: custId, mid: mid, ssoToken: sso, checksum: checksum, delegate: self)
        }

    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {

            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let clientId = (rootVC.clientIdTextField.text == "") ? "pg-mid-test-prod" : rootVC.clientIdTextField.text!
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let cardToken = cardTokenTextField.text!
            let tokenExpiry = cardExpireDateTextField.text!
            let TAVV = tAVVTextField.text!
            let panUniqueRefernce = panUniqueReferenceField.text!
            let cardSuffix = cardSuffix.text!

            guard let cardNumber = cardTokenTextField.text, !cardNumber.isEmpty else {
                self.showError(errorString: "Data Error")
                return
            }
            
            guard let cardExpireDate = cardExpireDateTextField.text, !cardExpireDate.isEmpty else {
                self.showError(errorString: "Data Error")
                return
            }
            
            guard let cardCVV = cardCVVTextField.text, !cardCVV.isEmpty else {
                self.showError(errorString: "Data Error")
                return
            }
         
            let updatedExpiry = cardExpireDate.replacingOccurrences(of: "/", with: "20")
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
            let custId = (rootVC.custIdTextField.text == "") ? "cid" : rootVC.custIdTextField.text!

            var request = URLRequest(url: URL(string: urlString)!)
            let bodyParams = ["head": ["channelId":"WAP","clientId":clientId,"requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":custId]]]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                request.httpBody = data
            } catch {
                print(error)
            }
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                guard let `self` = self, let data = data else {
                    return
                }
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let body = jsonDict["body"] as? [String : Any], let txnToken =  body["txnToken"] as? String {
                            DispatchQueue.main.async {
                                let model = AITokenizeCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.cardTypeSeg
                                                                                    .selectedSegmentIndex == 0 ? .debitCard :.creditCard  , authMode: self.authTypeSeg.selectedSegmentIndex == 0 ? .otp :.atm , cardId: nil, cardNumber: cardNumber, cvv: cardCVV, expiryDate: updatedExpiry, newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback",  isTokenizeCard: true, cardToken: cardToken, tokenExpiry: tokenExpiry, tAVV: TAVV, panUniqueRefernce: panUniqueRefernce, cardSuffix: cardSuffix)
                                self.appInvoke.callProcessTransactionAPI(selectedPayModel: model, delegate: self)
                            }
                        }
                    }
                }
                catch {
                    print(error)
                }
                }.resume()
            
        }
    }

}

