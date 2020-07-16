//
//  ViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 07/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK


class ViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var merchantIdTextField: UITextField!
    @IBOutlet weak var orderIdTextField: UITextField!
    @IBOutlet weak var ssoTokenTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var checksumField: UITextField!
    @IBOutlet weak var clientIdTextField: UITextField!
    @IBOutlet weak var flowTypeSegment: UISegmentedControl!
    //MARK: Private Properties
    
    //MARK: AIHandler expose all the API's from the PaytmNNativeSDK. so need to instantiate into your project to get all the exposed methods and properties.
    let appInvoke = AIHandler()
    var selectedFieldFrame: CGRect?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MARK: adding observers for the Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: To slide the View up on keyboard notification.
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
        let inRootView = self.view.convert(self.view.frame, to: UIApplication.shared.keyWindow?.rootViewController?.view).minY + (selectedFieldFrame?.maxY ?? 0)
        
        let diffrennce =  keyboardSize.minY - inRootView
        if diffrennce < 0 {
            self.view.frame.origin.y = diffrennce
        }
    }

    //MARK: On dismissing keeyboard, put the view to its original position.
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

    
    
    func initiateTransitionToken(callback: @escaping (String,String,String, String) -> Void) {
//        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
        let orderId = (self.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : self.orderIdTextField.text!
            let merchantId = (self.merchantIdTextField.text == "") ? "AliSub58582630351896" : self.merchantIdTextField.text!
            let amount = (self.amountTextField.text == "") ? "1" : self.amountTextField.text!
            let token = (self.ssoTokenTextField.text == "") ? "" : self.ssoTokenTextField.text!
            let clientId = (self.clientIdTextField.text == "") ? "pg-mid-test-prod" : self.clientIdTextField.text!
            //            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            
            let baseUrlString = (self.appInvoke.getEnvironent() == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let urlString = "\(baseUrlString)/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)"
            var request = URLRequest(url: URL(string: urlString)!)
            
            let bodyParams = ["head": ["channelId":"WAP","clientId":clientId, "requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"\(baseUrlString)/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]
            
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
                                callback(orderId,merchantId,txnToken, token)
//                                self.appInvoke.openRedirectionFlow(orderId : orderId, txnToken: txnToken, mid: merchantId, controller: self, delegate: self)
                            }
                        }
                    }
                }
                catch {
                    print(error)
                }
            }.resume()
//        }
    }

}

//MARK: - Button Action Methods
extension ViewController {
    
    @IBAction func openPaytm(_ sender: UIButton) {
        //MARK: show popUp for selecting environment.
        let alert = UIAlertController(title: "Environment", message: "Select the server environment in which you want to open paytm.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Staging", style: .default, handler: {[weak self] (action) in
            //hitTransaction api with selected environment,
            self?.hitInitiateTransactionAPI(.staging)
        }))
        alert.addAction(UIAlertAction(title: "Production", style: .default, handler: {[weak self] (action) in
            self?.hitInitiateTransactionAPI(.production)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AIDelegate
extension ViewController: AIDelegate {
 
    func didFinish(with success: Bool, response: [String : Any], error: String?, withUserCancellation hasUserCancelledTransaction: Bool) {
        let alert = UIAlertController(title: success ? "Success" : "Fail", message: String(describing: response), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - API Integration
extension ViewController {
    func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        let orderId = (self.orderIdTextField.text == "") ? "OrderTest" + "\(arc4random())" : self.orderIdTextField.text!
        let merchantId = (self.merchantIdTextField.text == "") ? "AliSub58582630351896" : self.merchantIdTextField.text!
        let amount = (self.amountTextField.text == "") ? "1" : self.amountTextField.text!
        let token = (self.ssoTokenTextField.text == "") ? "" : self.ssoTokenTextField.text!

        var request = URLRequest(url: URL(string: "https://securegw.paytm.in/theia/api/v1/initiateTransaction?mid=\(merchantId)&orderId=\(orderId)")!)

        let bodyParams = ["head": ["channelId":"WAP","clientId":"pg-mid-test-prod","requestTimestamp":"Time","signature":"CH","version":"v1"],"body":["callbackUrl":"https://securegw.paytm.in/theia/paytmCallback?ORDER_ID=\(orderId)&MID=\(merchantId)","mid":"\(merchantId)","orderId":"\(orderId)","requestType":"Payment","websiteName":"retail","paytmSsoToken":"\(token)","txnAmount":["value":"\(amount)","currency":"INR"],"userInfo":["custId":"cid"]]]

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
                            
                            self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeInhouseParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: .none, paymentModes: .wallet, redirectionUrl: "https://securegw.paytm.in/theia/paytmCallback"), delegate: self, controller: self)
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

extension ViewController : UITextFieldDelegate {
    
    func setToolBar(textFld: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem.init(title: "Done",
                                              style: UIBarButtonItem.Style.plain,
                                              target: self, action: #selector(doneClicked(sender:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spaceButton, doneButton], animated: false)
        textFld.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedFieldFrame = textField.frame
        setToolBar(textFld: textField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
