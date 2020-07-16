//
//  UPICollectViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 23/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class UPICollectViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var vpaAddressTextField: UITextField!
    @IBOutlet weak var switchSaveInstrument: UISwitch!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        vpaAddressTextField.text = self.appInvoke.getSavedVPA()
        vpaAddressTextField.delegate = self
    }
    
    
    //MARK: proceeed Payment with UPI Collect
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        self.proceedPayment(sender)
    }
    
    
    //MARK: Parms for Local Vault API
    func getParamsForSavedLocalVault() -> [String: Any] {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            var bodyParams = [String: Any]()
            bodyParams["CUSTID"] = "CUST001"
            bodyParams["MID"] = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            
            if !(rootVC.ssoTokenTextField.text ?? "").isEmpty {
                bodyParams["SSO_TOKEN"] = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            }
            
            bodyParams["REQUEST_TYPE"] = "DEFAULT"
            bodyParams["CHECKSUM"] = (rootVC.checksumField.text == "") ? "" : rootVC.checksumField.text!
            return bodyParams
        } else {
            return [:]
        }
    }
    
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            guard let vpaAddress = vpaAddressTextField.text, !vpaAddress.isEmpty else {
                self.showError(errorString: "vpaAddress is required.")
                return
            }
            
            
            
            //MARK: save current VPA Address for next time autofill
            if vpaAddress != appInvoke.getSavedVPA() {
                self.appInvoke.saveVPA(vpa: vpaAddress)
            }

            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL


            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                let model = AINativeNUPIarameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, amount: 1.0, paymentModes: .upi, vpaAddress: vpaAddress, upiFlowType: .collect, merchantInfo: nil, bankDetail: nil, redirectionUrl: "\(baseUrlString)/theia/paytmCallback")
                
                //collcect flow for UPI transaction
                self.appInvoke.callProcessTransitionAPIForCollect(selectedPayModel: model, delegate: self, controller: self, responseCallback: { responseDict in
                    
                    //TODO: For later version:
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
            
        }
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
}
