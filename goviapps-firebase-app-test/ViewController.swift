//
//  ViewController.swift
//  goviapps-firebase-app-test
//
//  Created by Maciej Serwicki on 1/19/16.
//  Copyright © 2016 Maciej Serwicki. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }

    
    @IBAction func fbBtnPressed(sender: UIButton!){
        
        let ref = Firebase(url: "https://GOVI-SHOWCASE.firebaseio.com")
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                                
                                //error handling missing
                                if error != nil {
                                    print("Login Failed \(error)")
                                } else {
                                    print("Logged In! \(authData)")
                                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                                    
                                    //could do error handlign with authData.provider
                                    let user = ["provider": authData.provider!, "test": "turkeydogetest"]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    
                                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                    
                                }
                                
                            })
                        }
                })
            }
        })
        
    }
    
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            //attempt logging in
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
             
                
                if error != nil {

                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        //Making New Account
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Could Not Create Account or Log In", message: "Please Try Again")
                            } else {
                                //account made successfully, log in
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {
                                    err, authData in
                                    
                                    let user = ["provider": authData.provider!, "test": "turkeydogetest2"]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    
                                    
                                } )
                                
                                    self.performSegueWithIdentifier (SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                            
                        })
                    } else if error.code == STATUS_EMAIL_INVALID {
                        self.showErrorAlert("Invalid Email Address", message: "Please Enter Email In This Format: name@example.com")
                    } else if error.code == STATUS_PASS_INVALID {
                        self.showErrorAlert("Invalid Password, Please Try Again", message: "Couldn't Make New Account Because \(email) Is Already In Use")
                    
                    } else {
                        self.showErrorAlert("Could Not Log In", message: "Please Try Again")
                        print(error)
                    }
                
                } else {
                    //Log In If Account Exists
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    
                }
                
                
            })
            
        } else {
            showErrorAlert("Email and Password Requried", message: "Please enter a valid email and password.")
        }
    }
    
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}

