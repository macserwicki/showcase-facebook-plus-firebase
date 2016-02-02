//
//  MaterialDesignButton.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/19/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class MaterialDesignButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 0.0)
        
    }

}
