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
    
    enum PollingType {
        case defaultPolling
        case customPolling
    }
    
    var pollingType: PollingType = .defaultPolling
    
    //MARK: IBOutlets
    @IBOutlet weak var vpaAddressTextField: UITextField!
    @IBOutlet weak var upiNumberTextField: UITextField!
    @IBOutlet weak var switchSaveInstrument: UISwitch!
    @IBOutlet weak var pollingSwitch: UISwitch!
    
    @IBOutlet weak var accessTokenSwitch: UISwitch!
    @IBOutlet weak var txnTokenSwitch: UISwitch!
    
    @IBAction func switchPollingType(_ sender: Any) {
        if pollingSwitch.isOn {
            pollingType = .customPolling
        }
        else {
            pollingType = .defaultPolling
        }
    }
    
    let referenceId = "ref_98765432151017"
    var verifiedVpaAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate(timeIntervalSince1970: 1596717607)
        print(date)
        vpaAddressTextField.text = self.appInvoke.getSavedVPA()
        vpaAddressTextField.delegate = self
    }
    
    
    //MARK: proceeed Payment with UPI Collect
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        self.proceedPayment(sender)
    }
    
    @IBAction func tapOnVerifyVPA(_ sender: UIButton) {
        guard let vpa = vpaAddressTextField.text, !vpa.isEmpty else {
            self.showError(errorString: "vpaAddress is required.")
            return
        }
        verifiedVpaAddress = vpa
        validateVPA(vpaAddress: verifiedVpaAddress)
    }
    
    @IBAction func tapOnVerifyUpiNumber(_ sender: UIButton) {
        guard let upiNumber = upiNumberTextField.text, !upiNumber.isEmpty else {
            self.showError(errorString: "numeric id is required.")
            return
        }
        validateVPA(upiNumber: upiNumber)
    }
    
    @IBAction func accessTokenSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            txnTokenSwitch.isOn = false
            accessTokenSwitch.isOn = true
        }
    }
    
    @IBAction func txnTokenSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            txnTokenSwitch.isOn = true
            accessTokenSwitch.isOn = false
        }
    }
    
    @IBAction func createCheckSum(_ sender: UIButton) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            rootVC.createChecksumForAccessToken(refrenceId: referenceId)
        }
    }
    
    
    func validateVPA(vpaAddress: String? = "", upiNumber: String? = "") {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
            let baseUrlString = (self.appInvoke.getEnvironent() == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let token = (rootVC.ssoTokenTextField.text == "") ? "" : rootVC.ssoTokenTextField.text!
            let checkSumToken = rootVC.checksumField.text ?? ""

            if accessTokenSwitch.isOn {
                //create token endPoint. to create accessToken
//                    let urlString = "https://stage-webapp.paytm.in/api/createAccessToken.php?mid=\(merchantId)&referenceId=\("\(referenceId)")"
                    let urlString =  "\(baseUrlString)/theia/api/v1/token/create?mid=\(merchantId))"
                    var request = URLRequest(url: URL(string: urlString)!)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.addValue("Basic cGF5dG1Vc2VyOkExaTFOZkw2TEc4NmtDdHdvZjNQQU8wTXVId21obTNhR1E=", forHTTPHeaderField: "Authorization")
                
                var head = [String:Any]()
                
                head["version"] = "v1"
                let timeStamp = Date().timeIntervalSince1970 * 1000 // timestamp in millisecond
                head["tokenType"] = "CHECKSUM"
                head["token"] = "\(checkSumToken)"

                var params = [String: Any]()
                params["head"] = head
                
                let bodyParams = ["mid":"\(merchantId)", "referenceId": "\(referenceId)"]
                params["body"] = bodyParams

                    do {
                        let data = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
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
                                        self.appInvoke.isVpaValidated(vpa: vpaAddress, upiNumber: upiNumber, mid: merchantId, tokenType: .acccess, token: accessToken, referenceId: self.referenceId) { (response, error) in
                                            if error != nil {
                                                let alert = UIAlertController(title: "Fail", message: (response?.isEmpty ?? false) ? (error ?? nil) : String(describing: response), preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                            } else {
                                                if let vpa = body["vpa"] as? String {
                                                    self.verifiedVpaAddress = vpa
                                                    print(vpa)
                                                }
                                                let alert = UIAlertController(title: "Success", message:  (response?.isEmpty ?? false) ? (error ?? nil) : String(describing: response), preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "Fail", message:  String(describing: jsonDict), preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                        catch {
                            print(error)
                        }
                    }.resume()
                    
                    return
            } else {
                rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, token) in
                    DispatchQueue.main.async {
                        self.appInvoke.isVpaValidated(vpa: vpaAddress, upiNumber: upiNumber, mid: merchantId, tokenType: .txntoken, token: txnToken, referenceId: orderId) { (response, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Fail", message: (response?.isEmpty ?? false) ? (error ?? nil) : String(describing: response), preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "Success", message:  (response?.isEmpty ?? false) ? (error ?? nil) : String(describing: response), preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                if let response = response, let body = response["body"] as? [String : Any], let vpa = body["vpa"] as? String {
                                    self.verifiedVpaAddress = vpa
                                }
                                print(response)
                            }
                        }
                    }
                }
            }
        }

    }
    
    //MARK: Parms for Local Vault API
    func getParamsForSavedLocalVault() -> [String: Any] {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            var bodyParams = [String: Any]()
            let custId = (rootVC.custIdTextField.text == "") ? "CUST001" : rootVC.custIdTextField.text!
            bodyParams["CUSTID"] = custId
            
            bodyParams["MID"] = (rootVC.merchantIdTextField.text == "") ? "SUBALI28053589241419" : rootVC.merchantIdTextField.text!
            
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
            guard let vpaAddress = verifiedVpaAddress, !vpaAddress.isEmpty else {
                self.showError(errorString: "vpaAddress is required.")
                return
            }
            
            
            //MARK: save current VPA Address for next time autofill
            if vpaAddress != appInvoke.getSavedVPA() {
                self.appInvoke.saveVPA(vpa: vpaAddress)
            }

            let urlScheme = (rootVC.urlSchemeTextField.text == "") ? "" : rootVC.urlSchemeTextField.text!

            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            
            var amount: CGFloat = 0.0
            if let floatAmount = Double(rootVC.transactionAmount) {
                amount = CGFloat(floatAmount)
            }

            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                let model = AINativeNUPIarameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, amount: amount, paymentModes: .upi, vpaAddress: vpaAddress, upiFlowType: .collect, merchantInfo: nil, bankDetail: nil, redirectionUrl: "\(baseUrlString)/theia/paytmCallback", urlScheme: urlScheme)
                
                //collcect flow for UPI transaction.
                //flexible polling handling  using public init UpiCollectConfigurations
                //shouldAllowCustomPolling = true in case merchant  want to handle his  own polling page
                //isAutoPolling = true:  if merchant wants sdk to handle polling itself and return completion of upiCollectPollingCompletion after polling completes. to handle response.
                self.appInvoke.callProcessTransitionAPIForCollect(selectedPayModel: model, delegate: self, upiPollingConfig: UpiCollectConfigurations(shouldAllowCustomPolling: (self.pollingType == .customPolling) ? true : false, isAutoPolling: true), responseCallback: { [weak self]responseDict in
                    
                    //MARK: Polling of transactionStatus API:
                    //if auto polling
                    self?.appInvoke.upiCollectPollingCompletion = { [weak self](status, model) in
                        print(status)
                        switch status {
                        case .failure, .success, .timeElapsed:
                            DispatchQueue.main.async { [weak self] in
                                let alert = UIAlertController(title: "", message: "transaction " + "\(status)", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self?.present(alert, animated: true, completion: nil)

                            }
                            
                        default: break
                        }
                    }
                    
                    // else
                    //MARK: here response of process transaction api is provided. If merchant want to call polling api on its own
                    // use appInvoke.pollingForStatus() to call status api. and implement your own polling logic
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
