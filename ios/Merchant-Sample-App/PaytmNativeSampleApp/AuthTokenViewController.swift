//
//  AuthTokenViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 30/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class AuthTokenViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
   //MARK: Get Auth Token, in case app is installed paytm app invoked, otherwise redirection flow is innvoked.
    @IBAction func tappedOnToken(_ sender: UIButton) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
        let merchantId = (rootVC.merchantIdTextField.text == "") ? "AliSub58582630351896" : rootVC.merchantIdTextField.text!
        let clientId = (rootVC.clientIdTextField.text == "") ? "pg-mid-test-prod" : rootVC.clientIdTextField.text!
        self.appInvoke.getAuthToken(clientId: clientId, mid: merchantId) { (status) in
            switch status {
            case .inProcess:
                break
            case .appNotInstall:
                // open redirection flow
                self.showRedirectPagePaytm()
            case .error:
                self.showError(errorString: "Something went wrong")
            }
        }
        }
    }
    
    //MARK: Redirection flow is instanciated with auth token
    func showRedirectPagePaytm() {
        initiateTransitionToken()
    }
    
    
    func initiateTransitionToken() {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                self.appInvoke.openRedirectionFlow(orderId : orderId, txnToken: txnToken, mid: merchantId, controller: self, delegate: self)
                
            }
        }
        
    }
    
}
