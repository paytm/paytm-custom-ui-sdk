//
//  CGFloatExtensions.swift
//  PaytmNativeSampleApp
//
//  Created by Aakash Srivastava on 01/02/21.
//  Copyright © 2021 Sumit Garg. All rights reserved.
//

import UIKit

extension CGFloat {
    
    init?(string: String) {
        guard let number = NumberFormatter().number(from: string) else {
            return nil
        }
        self.init(number.floatValue)
    }
    
    var string: String {
        return "\(self)"
    }
}
