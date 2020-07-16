//
//  AllPayModesViewController.swift
//  PaytmNativeSampleApp
//
//  Created by Sumit Garg on 15/01/20.
//  Copyright © 2020 Sumit Garg. All rights reserved.
//

import UIKit
import PaytmNativeSDK

class AllPayModesViewController: UIViewController {
    
    let appInvoke = AIHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedOnToken(_ sender: UIButton) {
        self.appInvoke.getAuthToken(clientId: "mall-app", mid: "AliSub58582630351896") { (status) in
            print(status)
        }
    }
}
