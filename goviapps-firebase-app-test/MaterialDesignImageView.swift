//
//  MaterialDesignImageView.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/19/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit

class MaterialDesignImageView: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.3).CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }

}
