//
//  NBViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

//MARK: class used to pay when Net Banking is selected.
class NBViewController: BaseViewController {

    @IBOutlet weak var channelIdTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelIdTextField.delegate = self
        channelIdTextField.text = self.appInvoke.getSavedNetBankingMethod()
    }
    
    //MARK: Invoke proceession Transaction Api, with net banking pay method
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
        
    }
    
    // MARK: this method is invoked when thee user wants to cache the last used Net Banking Method, preferably when the transition is successfull, after that channel code can be cached.
    func saveNetBankingMethod(channelCode: String) {
         self.appInvoke.saveNetBankingMethod(channelCode: channelCode)
    }
    
    
    //MARK: Action to fetch all NetBanking Channels available. This Api used transation Token.
    @IBAction func tapOnNBChannels(_ sender: Any) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let clientId = (rootVC.clientIdTextField.text == "") ? "pg-mid-test-prod" : rootVC.clientIdTextField.text!

            let baseUrlString = (self.appInvoke.getEnvironent() == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
            var request = URLRequest(url: URL(string: urlString)!)

            let bodyParams = ["head": ["channelId":"WAP","clientId":clientId, "requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken": "\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]
            
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
                                self.appInvoke.fetchNetBankingChannels(selectedPayModel: AINativeNBParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: .netBanking, channelCode: "", redirectionUrl: "\(baseUrlString)/theia/paytmCallback"), delegate: self)
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
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            guard let channelCode = channelIdTextField.text, !channelCode.isEmpty else {
                self.showError(errorString: "Channel code is required.")
                return
            }
            
            //MARK: Call to save last used Net Banking Method.
            self.saveNetBankingMethod(channelCode: channelCode)

            let orderId = (rootVC.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : rootVC.orderIdTextField.text!
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let amount = (rootVC.amountTextField.text == "") ? "1" : rootVC.amountTextField.text!
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none


            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
            var request = URLRequest(url: URL(string: urlString)!)
            
            let bodyParams = ["head": ["channelId":"WAP","clientId":"pg-mid-test-prod", "requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]
            
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
                                //MAARK: Process transaction API to initiat Payment.
                                self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeNBParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: false, mid: merchantId, flowType: flowType, paymentModes: .netBanking, channelCode: channelCode, redirectionUrl: "\(baseUrlString)/theia/paytmCallback"), delegate: self, controller: self)
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

