//
//  NewCardViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class NewCardViewController: BaseViewController {
    var saveInstrument: String = "0"
    var apiCallMade = false
    var selectedModel: AINativeSavedCardParameterModel?
    
    
    //MARK: set variable to saveInstrument ("0"/"1") for local vault.
    @IBAction func actionSaveInstrument(_ sender: Any) {
        if self.switchSaveInstrument.isOn {
            self.saveInstrument = "1"
        } else {
            self.saveInstrument = "0"
        }
    }
    
    @IBOutlet weak var switchSaveInstrument: UISwitch!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var cardExpireDateTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    
    @IBOutlet weak var authTypeSeg: UISegmentedControl!
    @IBOutlet weak var cardTypeSeg: UISegmentedControl!
    
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
            self.appInvoke.getInstrumentFromLocalVault(custId: "CUST001", mid: mid, ssoToken: sso, checksum: checksum, delegate: self, controller: self)
        }

    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {

            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "8051cc88-3833-41d7-a271-5d6344af9200" : rootVC.ssoTokenTextField.text!
            let clientId = (rootVC.clientIdTextField.text == "") ? "pg-mid-test-prod" : rootVC.clientIdTextField.text!
//            let sso = "a05a7dd6-b245-4d88-9bd8-c23be9218000"
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
         
            let updatedExpiry = cardExpireDate.replacingOccurrences(of: "/", with: "20")
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"

            var request = URLRequest(url: URL(string: urlString)!)
            let bodyParams = ["head": ["channelId":"WAP","clientId":clientId,"requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]
            
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                request.httpBody = data
            } catch{
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
                                self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeSavedCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.cardTypeSeg
                                    .selectedSegmentIndex == 0 ? .debitCard :.creditCard  , authMode: self.authTypeSeg.selectedSegmentIndex == 0 ? .otp :.atm , cardId: nil, cardNumber: cardNumber, cvv: cardCVV, expiryDate: updatedExpiry, newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback"), delegate: self, controller: self)
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
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
            
            var request = URLRequest(url: URL(string: urlString)!)
            let bodyParams = ["head": ["channelId":"WAP","clientId":"pg-mid-test-prod","requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]
            do {
                let data = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
                request.httpBody = data
            } catch{
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
                                self.selectedModel = AINativeSavedCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.authTypeSeg.selectedSegmentIndex == 0 ? .debitCard :.creditCard  , authMode: self.authTypeSeg.selectedSegmentIndex == 0 ? .otp :.atm , cardId: nil, cardNumber: bin, cvv: "", expiryDate: "", newCard: true, saveInstrument: self.saveInstrument, redirectionUrl: "\(baseUrlString)/theia/paytmCallback")
                                
                                //fetch bin call with transaction token
                                self.appInvoke.fetchBin(selectedPayModel: self.selectedModel!, delegate: self, controller: self)
                            }
                        } else {
                            self.showError(errorString: jsonDict.description)
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

