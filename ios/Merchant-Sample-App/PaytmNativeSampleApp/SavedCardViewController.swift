//
//  SavedCardViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 23/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class SavedCardViewController:BaseViewController {
    
    @IBOutlet weak var cardIdTextField: UITextField!
    @IBOutlet weak var cardExpireDateTextField: UITextField!
    @IBOutlet weak var cardCVVTextField: UITextField!
    
    @IBOutlet weak var authTypeSeg: UISegmentedControl!
    @IBOutlet weak var cardTypeSeg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Process Transition with saved Debit/Credit card
    @IBAction func tappedOnPTC(_ sender: UIButton) {
        self.proceedPayment(sender)
    }
    
    override func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        if let childVC = self.children.first as? UINavigationController, let rootVC = childVC.viewControllers.first as? ViewController {
            
            guard let cardId = cardIdTextField.text, !cardId.isEmpty else {
                self.showError(errorString: "Data Error")
                return
            }
//            guard let cardExpireDate = cardExpireDateTextField.text, !cardExpireDate.isEmpty else {
//                self.showError(errorString: "Data Error")
//                return
//            }
            
            guard let cardCVV = cardCVVTextField.text, !cardCVV.isEmpty else {
                self.showError(errorString: "Data Error")
                return
            }
            
            
            let flowType: AINativePaymentFlow = AINativePaymentFlow(rawValue: (rootVC.flowTypeSegment.titleForSegment(at: rootVC.flowTypeSegment.selectedSegmentIndex) ?? "NONE")) ?? .none
            let baseUrlString = (env == .production) ? kProduction_ServerURL : kStaging_ServerURL

            rootVC.initiateTransitionToken { [weak self](orderId, merchantId, txnToken, ssoToken) in
                guard let `self` = self else {
                    return
                }
                self.appInvoke.callProcessTransactionAPI(selectedPayModel: AINativeSavedCardParameterModel.init(withTransactionToken: txnToken, orderId: orderId, shouldOpenNativePlusFlow: true, mid: merchantId, flowType: flowType, paymentModes: self.cardTypeSeg.selectedSegmentIndex == 0 ? .debitCard :.creditCard , authMode:  self.authTypeSeg.selectedSegmentIndex == 0 ? .otp :.atm , cardId: cardId, cardNumber: nil, cvv: cardCVV, expiryDate: "", newCard: false, saveInstrument: "0", redirectionUrl: "\(baseUrlString)/theia/paytmCallback"), delegate: self)

            }
        }
    }
}

