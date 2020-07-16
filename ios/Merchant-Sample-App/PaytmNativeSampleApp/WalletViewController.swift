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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        super.proceedPayment(sender)
    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none

            //initiatee Transaction
            rootVC.initiateTransitionToken { (orderId, merchantId, txnToken, ssoToken) in
                DispatchQueue.main.async {
                    // payment through wallet
                    self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeInhouseParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: .wallet
                        , redirectionUrl: "\(baseUrlString)/theia/paytmCallback"), delegate: self, controller: self)
                }
            }
        }
    }
    
    
}
