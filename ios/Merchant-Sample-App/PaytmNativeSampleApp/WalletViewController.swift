//
//  WalletViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class WalletViewController: BaseViewController {
    @IBOutlet weak var labelInsufficientBalance: UILabel!
    @IBOutlet weak var buttonAddAndPay: UIButton!
    @IBOutlet weak var appInvokeSwitch: UISwitch!
    
    var appInvokeCallback: (() -> Void)?
    var shouldAppInvoke: Bool = false
    
    @IBAction func AddAndPay(_ sender: Any) {
        self.appInvokeCallback?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelInsufficientBalance.isHidden = true
        buttonAddAndPay.isHidden = true
    }
    
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
    }
    
    @IBAction func switchAppInvoke(_ sender: Any) {
        shouldAppInvoke = appInvokeSwitch.isOn
    }
    
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            
            
            //initiatee Transaction
            rootVC.initiateTransitionToken { [weak self](orderId, merchantId, txnToken, ssoToken) in
                guard let `self` = self else {
                    return
                }

                DispatchQueue.main.async {
                    let transactionAmount = rootVC.transactionAmount
                    
                    let selectedPayModel = AINativeInhouseParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: .wallet, redirectionUrl: "\(baseUrlString)/theia/paytmCallback")
                    guard !self.shouldAppInvoke else {
                        self.appInvoke.openPaytm(selectedPayModel: selectedPayModel, merchantId: merchantId, orderId: orderId, txnToken: txnToken, amount: transactionAmount, callbackUrl: "", delegate: self, environment: env)
                        return
                    }
                    
                    //REMARK: call upifetchPayOptions api to get upiProfile of the user
                    self.fetchPayOptions(selectedPayModel: selectedPayModel, env: env, txnToken: txnToken, orderId: orderId, mid: merchantId, transactionAmount: transactionAmount) {  (status) in
                        if status {
                            self.appInvoke.callProcessTransactionAPI(selectedPayModel: selectedPayModel, delegate: self)
                            
                        } else {
                            self.showError(errorString: "something went wrong")
                        }
                        
                    }
                }
            }
        }
    }
    
    func fetchPayOptions(selectedPayModel: AINativeInhouseParameterModel, env: AIEnvironment, txnToken: String, orderId: String, mid: String, transactionAmount: String , callBack: @escaping (Bool) -> Void) {
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v2/fetchPaymentOptions?mid=\(mid)&orderId=\(orderId)"
            
            var request = URLRequest(url: URL(string: urlString)!)
            let bodyParams = ["head": ["channelId":"WAP","requestTimestamp":"Time","version":"v1", "txnToken": txnToken]]
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
                    if let err = error {
                        self.showError(errorString: "\(err.localizedDescription)")
                        return
                    }
                    if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                        print(jsonDict)
                        if let body = jsonDict["body"] as? [String : Any] {
//                            print(body)
                            if let merchantPayOptions = body["merchantPayOption"] as? [String: Any], let paymodes = merchantPayOptions["paymentModes"] as? [[String: Any]]{
                                paymodes.forEach { (paymode) in
                                    if let mode = paymode["paymentMode"] as? String, mode == "BALANCE" {
                                        if let channels = paymode["payChannelOptions"] as? [[String: Any]] {
                                            if !channels.isEmpty {
                                                
                                                if let channel = channels.first, let balanceinfo = channel["balanceInfo"] as? [String:Any], let accountInfo = balanceinfo["accountBalance"] as? [String:Any], let value = accountInfo["value"] as? String, let floatValueWallet = Float(value) {
                                                    print(value)
                                                    if let transactionValue = Float(transactionAmount),  transactionValue > floatValueWallet {
                                                        // insufficient balance -> show option for app invoke
                                                        self.handleForAppInvoke(selectedPayModel: selectedPayModel, merchantId: mid, orderId: orderId, txnToken: txnToken, amount: transactionAmount, callbackUrl: "", delegate: self, environment: env)
                                                        callBack(false)
                                                        return
                                                    } else {
                                                        callBack(true)

                                                    }
                                                }
                                            }
                                        }
                                    }
                                 }
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
    
    
    func handleForAppInvoke(selectedPayModel: AINativeInhouseParameterModel, merchantId: String, orderId: String, txnToken: String, amount: String, callbackUrl : String?, delegate: AIDelegate, environment: AIEnvironment) {
        DispatchQueue.main.async {
            self.labelInsufficientBalance.isHidden = false
            self.buttonAddAndPay.isHidden = false
        }
        self.appInvokeCallback = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            
            weakSelf.appInvoke.openPaytm(selectedPayModel: selectedPayModel, merchantId: merchantId, orderId: orderId, txnToken: txnToken, amount: amount, callbackUrl: "", delegate: weakSelf, environment: environment)
        }
    }
    
    
}

