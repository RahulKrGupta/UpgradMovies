//
//  CustomLabel.swift
//  Harmony
//
//  Created by Rahul Gupta on 07/05/16.
//  Copyright © 2016 Rahul Gupta. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}

