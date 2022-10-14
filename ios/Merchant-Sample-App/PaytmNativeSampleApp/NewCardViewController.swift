//
//  NewCardViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

enum Authtype{
    case authToken
    case txnToken
}


class NewCardViewController: BaseViewController {
    var saveInstrument: String = "0"
    var apiCallMade = false
    var selectedModel: AINativeSavedCardParameterModel?
    var authenticationType: Authtype = .txnToken
    var selectedCardType : AINativePaymentModes = .debitCard
    var authModeType : AuthMode = .otp
    

    @IBOutlet weak var getPTC: UISwitch!
    @IBOutlet weak var switchSaveInstrument: UISwitch!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var cardExpireDateTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    
    @IBOutlet weak var authTypeSeg: UISegmentedControl!
    @IBOutlet weak var cardTypeSeg: UISegmentedControl!
    @IBOutlet weak var segIsAAuthToken: UISwitch!
    @IBOutlet weak var isEligibleForCoftSwitch: UISwitch!
    @IBOutlet weak var coftConsentSwitch: UISwitch!

    var isCardPTCInfoRequired:Bool = false
    
    @IBAction func updateGetPTC(_ sender: Any) {
        if self.getPTC.isOn {
            isCardPTCInfoRequired = true
        } else {
            isCardPTCInfoRequired = false
        }
    }
        
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
    
    //MARK: set variable to saveInstrument ("0"/"1") for local vault.
    @IBAction func actionSaveInstrument(_ sender: Any) {
        if self.switchSaveInstrument.isOn {
            self.saveInstrument = "1"
        } else {
            self.saveInstrument = "0"
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTextField.delegate = self
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
    
    @IBAction func isEligibleForCoftSwitchAction(_ sender: UISwitch) {
        isEligibleForCoftSwitch.isOn = sender.isOn
    }
    
    @IBAction func coftConsentSwitchAction(_ sender: UISwitch) {
        coftConsentSwitch.isOn = sender.isOn
    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {

            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let clientId = (rootVC.clientIdTextField.text == "") ? "pg-mid-test-prod" : rootVC.clientIdTextField.text!
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            
            guard let cardNumber = cardNumberTextField.text, !cardNumber.isEmpty else {
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
         
            let urlScheme = (rootVC.urlSchemeTextField.text == "") ? "" : rootVC.urlSchemeTextField.text!
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
                                let model = AINativeSavedCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.cardTypeSeg
                                                                                    .selectedSegmentIndex == 0 ? .debitCard :.creditCard  , authMode: self.authTypeSeg.selectedSegmentIndex == 0 ? .otp :.atm , cardId: nil, cardNumber: cardNumber, cvv: cardCVV, expiryDate: updatedExpiry, newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback",  isEligibleForCoft: self.isEligibleForCoftSwitch.isOn ? true: false, isCoftUserConsent: self.coftConsentSwitch.isOn ? true: false, isCardPTCInfoRequired: self.isCardPTCInfoRequired, urlScheme: urlScheme)
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
    
    
    
 //MARK: API to fetch bin deetails wit initial 6 card number digits
    func fetchBin(bin: String, _ env: AIEnvironment) {
        
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            apiCallMade = true
            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlScheme = (rootVC.urlSchemeTextField.text == "") ? "" : rootVC.urlSchemeTextField.text!

            _ = (self.cardNumberTextField.text == "") ? "" : self.cardNumberTextField.text
            //if auth token is requireed
            if authenticationType == .authToken {
                //create token endPoint. to create accessToken
                
                    let urlString = "https://stage-webapp.paytm.in/api/createAccessToken.php?mid=\(merchantId)&referenceId=\("REF_1599222064")"
                    //let urlString =  "\(baseUrlString)/theia/api/v1/token/create?mid=\(merchantId)&referenceId=\("ref_123123123")"
                    var request = URLRequest(url: URL(string: urlString)!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Basic cGF5dG1Vc2VyOkExaTFOZkw2TEc4NmtDdHdvZjNQQU8wTXVId21obTNhR1E=", forHTTPHeaderField: "Authorization")
                
                    let bodyParams = ["mid":"\(merchantId)", "referenceId": "REF_1599222064"]
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                        request.httpBody = data
                    } catch {
                        print(error)
                    }
                    URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
                        guard let `self` = self, let data = data else {
                            return
                        }
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                                print(jsonDict)
                                if let body = jsonDict["body"] as? [String : Any], let accessToken = body["accessToken"] as? String {
                                    DispatchQueue.main.async {
                                        self.selectedModel = AINativeSavedCardParameterModel.init(withTransactionToken: accessToken, tokenType: TokenType.acccess, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.selectedCardType , authMode: self.authModeType , cardId: nil, cardNumber: bin, cvv: "", expiryDate: "", newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback", reference_Id: "REF_1599222064", urlScheme: urlScheme)
                                        
                                        //fetch bin call with transaction token
                                        self.appInvoke.fetchBin(selectedPayModel: self.selectedModel!, delegate: self)
                                        
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        var errMsg : String = "API error"
                                        if let body = jsonDict["body"] as? [String : Any], let resultInfo = body["resultInfo"] as? [String : Any], let msg = resultInfo["resultMsg"] as? String
                                        {
                                            errMsg = msg
                                            self.showError(errorString: errMsg)
                                        }
                                        else if let message = jsonDict["msg"] as? String
                                        {
                                            DispatchQueue.main.async {
                                                if message == "No Response"{
                                                    self.fetchBin(bin: self.cardNumberTextField.text ?? "", .production)
                                                }else{
                                                    errMsg = message
                                                    self.showError(errorString: errMsg)
                                                }
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                        catch {
                            print(error)
                        }
                    }.resume()
                    
                    return
            }
            else {
                
                //else if flow is of txnToken .
                let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
                var request = URLRequest(url: URL(string: urlString)!)
                let custId = (rootVC.custIdTextField.text == "") ? "cid" : rootVC.custIdTextField.text!
                let bodyParams = ["head": ["channelId":"WAP","clientId":"pg-mid-test-prod","requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":custId]]]
                
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
                            print(jsonDict)
                            if let body = jsonDict["body"] as? [String : Any], let txnToken =  body["txnToken"] as? String {
                                DispatchQueue.main.async {
                                    self.selectedModel = AINativeSavedCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.selectedCardType, authMode: self.authModeType, cardId: nil, cardNumber: bin, cvv: "", expiryDate: "", newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback", urlScheme: urlScheme)
                                    
                                    //fetch bin call with transaction token
                                    self.appInvoke.fetchBin(selectedPayModel: self.selectedModel!, delegate: self)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.showError(errorString: jsonDict.description)
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
    
    func getResponse(orderId: String, completion: @escaping ((String?)->())) {
        
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            //let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub97944711094182" : rootVC.merchantIdTextField.text!
            //let ssoToken = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let custId = (rootVC.custIdTextField.text == "") ? "cid" : rootVC.custIdTextField.text!

            let bodyParams = """
            {
            "paytmSsoToken": ssoToken,
            "mid": "\(merchantId)",
            "orderId": "\(orderId)",
            "websiteName":"retail",
            "requestType":"Payment",
            "txnAmount":{
            "value":"\(amount)",
            "currency":"INR"
            },
            "userInfo": {
            "custId":"\(custId)"
            },
            "callbackUrl":"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)"
            }
            """
            
            var body = URLComponents()
            body.queryItems = [URLQueryItem(name: "json_string", value: bodyParams)]
            
            //var request = URLRequest(url: URL(string: "https://stage-webapp.paytm.in/checksum/generate.php?mid=\(merchantId)")!)
            
             let urlString = "https://stage-webapp.paytm.in/api/getResponse.php?mid=\(merchantId)&orderId=\(orderId)" //this will work for both staging and prod
            if let url = URL(string: urlString){
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Basic cGF5dG1Vc2VyOkExaTFOZkw2TEc4NmtDdHdvZjNQQU8wTXVId21obTNhR1E=", forHTTPHeaderField: "Authorization")
                //0request.httpBody = body.query?.data(using: .utf8)
                URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {
                        completion(nil)
                        return
                    }
                    
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                            print(jsonDict)
                            let checksum = jsonDict["checksum"] as? String
                            completion(checksum)
                        }
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }
   
}


extension NewCardViewController  {
//    
//    func setToolBar(textFld: UITextField) {
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem.init(title: "Done",
//                                              style: UIBarButtonItem.Style.plain,
//                                              target: self, action: #selector(doneClicked(sender:)))
//        
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        toolbar.setItems([spaceButton, doneButton], animated: false)
//        textFld.inputAccessoryView = toolbar
//    }
//    
//    @objc func doneClicked(sender: AnyObject) {
//        self.view.endEditing(true)
//    }
//    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        setToolBar(textFld: textField)
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let prospectiveTextReplaced = (currentText as NSString).replacingCharacters(in: range, with: string)
        let prospectiveText = prospectiveTextReplaced.replacingOccurrences(of: " ", with: "")
        
        
         if prospectiveText.count > 5  && !apiCallMade && textField == cardNumberTextField {
            fetchBin(bin: prospectiveText, self.appInvoke.getEnvironent())
        }
        
        if prospectiveText.count < 5 {
            apiCallMade = false
        }

        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        apiCallMade = false
        return true
    }
}

