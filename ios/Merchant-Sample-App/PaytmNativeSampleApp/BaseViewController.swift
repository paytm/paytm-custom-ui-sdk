//
//  BaseViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK


class BaseViewController: UIViewController {
  
    //MARK: Private Properties
    private(set) lazy var appInvoke = AIHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
//        showEnvironmentAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    private func showEnvironmentAlert() {
        let alert = UIAlertController(title: "Environment", message: "Select the server environment in which you want to operate.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Staging", style: .default, handler: {[weak self] (action) in
            self?.appInvoke.setEnvironment(.staging)
        }))
        
        alert.addAction(UIAlertAction(title: "Production", style: .default, handler: {[weak self] (action) in
            self?.appInvoke.setEnvironment(.production)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
    // select environment(prod/stage) and initiateTrannsaction
    func proceedPayment(_ sender: UIButton) {
        let alert = UIAlertController(title: "Environment", message: "Select the server environment in which you want to operate.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Staging", style: .default, handler: {[weak self] (action) in
            self?.appInvoke.setEnvironment(.staging)
            self?.hitInitiateTransactionAPI(.staging)
        }))
        alert.addAction(UIAlertAction(title: "Production", style: .default, handler: {[weak self] (action) in
            self?.appInvoke.setEnvironment(.production)
            self?.hitInitiateTransactionAPI(.production)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
     func hitInitiateTransactionAPI(_ env: AIEnvironment) {
        
    }

    
    func showError(errorString : String) {
        let alert = UIAlertController(title: "Error", message: errorString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
           alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AIDelegate
extension BaseViewController: AIDelegate {

    func didFinish(with success: Bool, response: [String : Any], error: String?, withUserCancellation hasUserCancelledTransaction: Bool) {
        let alert = UIAlertController(title: success ? "Success" : "Fail", message: response.isEmpty
            ? error ?? nil : String(describing: response), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            if self.presentedViewController == nil {
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                self.presentedViewController?.dismiss(animated: true, completion: {
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func openPaymentController(_ controller: UIViewController) {
        present(controller, animated: true, completion: nil)
    }
}



extension BaseViewController: UITextFieldDelegate{
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
        setToolBar(textFld: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
