//
//  UPIIntentViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Aman Gupta on 25/06/21.
//  Copyright © 2021 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class UPIIntentViewController: BaseViewController {
    @IBOutlet weak var gpaySwitch: UISwitch!
    @IBOutlet weak var paytmSwitch: UISwitch!
    @IBOutlet weak var phonepeSwitch: UISwitch!
    
    var selectedpayType = PspApp.paytm
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
    }
    
    @IBAction func gpaySwitch(_ sender: UISwitch) {
        if sender.isOn {
            gpaySwitch.isOn = true
            paytmSwitch.isOn = false
            phonepeSwitch.isOn = false
            selectedpayType = .gPay
        }
    }
    
    @IBAction func paytmSwitch(_ sender: UISwitch) {
        if sender.isOn {
            gpaySwitch.isOn = false
            paytmSwitch.isOn = true
            phonepeSwitch.isOn = false
            selectedpayType = .paytm
        }
    }
    
    @IBAction func phonePeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            gpaySwitch.isOn = false
            paytmSwitch.isOn = false
            phonepeSwitch.isOn = true
            selectedpayType = .phonePe
        }
    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {

            //initiatee Transaction
            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                DispatchQueue.main.async {
                    
                    self.appInvoke.callProcessTransactionAPIForUPIIntent(orderId: orderId, mid: merchantId, txnToken: txnToken, pspApp: self.selectedpayType) { (response, error) in
                        if error != nil {
                            print(error ?? "")
                            return
                        }
                        if let body = response?["body"] as? [String: Any], let deepLinkInfo = body["deepLinkInfo"] as? [String: Any], let deepLink = deepLinkInfo["deepLink"] as? String {
                            print(deepLink)
                            let urlString = deepLink + "&source_callback=paytmmp"
                            print(urlString)

                            if let url = URL(string: urlString) {
                                var isPaytmAppExist :Bool = false
                                if UIApplication.shared.canOpenURL(url) {
                                    isPaytmAppExist = true
                                }
                                if isPaytmAppExist {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    let alert = UIAlertController(title: "DeepLink", message: deepLink, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        } else {
                            let alert = UIAlertController(title: "Response", message: (response?.isEmpty ?? false)
                                                            ? (
                                                                error ?? nil) : String(describing: response), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        print(response)
                    }
                }
            }
        }
    }
    
    
}
