//
//  UPIPushViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 18/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class UPIPushViewController: BaseViewController {
    
    var vpaAddress = ""
    var vpaDetails = [String:Any]() {
        didSet {
            if let vpa = vpaDetails["name"] as? String {
                vpaAddress = vpa
            }
        }
    }
    var merchantDetails = [String : Any]()


    var bankDetails = [String : Any]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL

            //initiatee Transaction
            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                DispatchQueue.main.async {
                    
                    //REMARK: call upifetchPayOptions api to get upiProfile of the user
                    self.fetchPayOptions(env: env, txnToken: txnToken, orderId: orderId, mid: merchantId) {  (status) in
                        
                        //if no vpaAddress is theree -> no profile exist -> createe upi profile
                        guard !self.vpaAddress.isEmpty else {
                            DispatchQueue.main.async {
                            self.showError(errorString: "You don't have a UPI Profile")
                            }
                            return
                        }
                        
                        // proced paymeent through selectd bank and vpa(bankDetails and vpaAddreess) to a merchant(self.merchantDetails)
                        self.appInvoke.callProcessTransactionAPIForUPI(selectedPayModel: AINativeNUPIarameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, amount: 1.0, paymentModes: .upi, vpaAddress: self.vpaAddress, upiFlowType: .push, merchantInfo: self.merchantDetails, bankDetail: self.bankDetails), completion: { (status) in
                            
                            switch status {
                            case .appNotInstall:
                                //if app is not installed then use collect flow for UPI payments
                                DispatchQueue.main.async {
                                    let model = AINativeNUPIarameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, amount: 1.0, paymentModes: .upi, vpaAddress: self.vpaAddress, upiFlowType: .collect, merchantInfo: nil, bankDetail: nil, redirectionUrl: "\(baseUrlString)/theia/paytmCallback")
                                    self.collectFlow(model: model)
                                }
                                
                            case .inProcess:
                                self.showError(errorString: "App invoke")
                            case .error:
                                self.showError(errorString: "something went wrong")
                            @unknown default:
                                break
                            }
                        })

                        }
                }
            }
        }
    }
    
    
    
    //MARK: USE Collect flow
    func collectFlow(model: AINativeNUPIarameterModel) {
            self.appInvoke.callProcessTransitionAPIForCollect(selectedPayModel: model, delegate: self, controller: self, responseCallback: { responseDict in
                
                //MARK: Polling of transactionStatus API
                //if auto polling
                self.appInvoke.upiCollectPollingCompletion = { (status, model) in
                    print(status)
                    
                    let alert = UIAlertController(title: "", message: "transaction " + "\(status)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    switch status {
                    case .failure: break
                    case .success: break
                    default: break
                    }
                }
                
                // else
                //MARK: here response of process transaction api is provided. If merchant want to call polling api on its own
                //                                    !self.appInvoke.UpiCollectConfigurations.autoPolling  {
                ////                                        self.appInvoke.
                //                                    }
                //                                    print(responseDict)
            })
    }
    
    
    
    func convertJSON(dict : [String : Any]) -> String {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
        if let jsonString = String(data: jsonData!, encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return jsonString
        }
        return ""
    }
    
    
    
    func convertStringToJSON(jsonString : String) -> [String : Any]? {
        if let jsonString1 = jsonString.removingPercentEncoding {
            let jsonData = jsonString1.data(using: .utf8)!
            if let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves) as? [String : Any]{
                return dictionary
            }
        }
        return nil
    }
    
    
    
    
    //MARK: API fetchPayOptions -> get upi profile of the user -> get merchant details, bankDetails, vpaDetails -> use these info for showing the list of saved vpa list, and select one of them to proceed payment through push flow. For demo purpose we have picked top vpa details for payment.
    func fetchPayOptions(env: AIEnvironment, txnToken: String, orderId: String, mid: String , callBack: @escaping (Bool) -> Void) {
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
                    if let jsonDict = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print(jsonDict)
                        if let body = jsonDict["body"] as? [String : Any] {
                            if let merchantDetail = body["merchantDetails"] as? [String: Any] {
                                self.merchantDetails = merchantDetail
                            }
                            
                            if let merchantPayOptions = body["merchantPayOption"] as? [String: Any], let upiProfile = merchantPayOptions["upiProfile"] as? [String: Any], let respDetails = upiProfile["respDetails"] as? [String: Any], let profileDetail = respDetails["profileDetail"] as? [String: Any], let vpaDetails = profileDetail["vpaDetails"] as? [[String:Any]], let bankAccounts = profileDetail["bankAccounts"] as? [[String: Any]] {
                                if !vpaDetails.isEmpty {
                                    self.vpaDetails = vpaDetails[0]
                                }

                                if !bankAccounts.isEmpty {
                                    self.bankDetails = bankAccounts[0]
                                }
                            }
                            callBack(true)
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



