//
//  DataService.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/19/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let ds = DataService()

    private var _REF_BASE = Firebase(url: "https://govi-showcase.firebaseio.com")
    
    var REF_BASE: Firebase {
       return _REF_BASE
    }
}