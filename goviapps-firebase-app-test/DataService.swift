//
//  DataService.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/19/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = "https://govi-showcase.firebaseio.com"

class DataService {
    static let ds = DataService()

    private var _REF_BASE = Firebase(url: URL_BASE)
    
    private var _REF_POSTS = Firebase(url: "\(URL_BASE)/posts")
    
    private var _REF_USERS = Firebase(url: "\(URL_BASE)/users")
    
    var REF_BASE: Firebase {
       return _REF_BASE
    }
    
    var REF_POSTS: Firebase {
        return _REF_POSTS
    }
    
    var REF_USERS: Firebase {
        return _REF_USERS
    }
    
    //provider, username
    func createFirebaseUser(uid: String, user: Dictionary<String, String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }
    
    //Description, ImageURL, Likes
    func createFirebasePost(pid: String, post: Dictionary<String, String>) {
        REF_POSTS.childByAppendingPath(pid).setValue(post)
    }
    
}