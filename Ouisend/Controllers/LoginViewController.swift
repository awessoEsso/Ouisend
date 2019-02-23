//
//  LoginViewController.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email, .userBirthday ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}


extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did Logout")
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(result)
        switch result {
        case .success( _, _, let accessToken):
            print("Success")
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
                if let error = error {
                    self.handleErrorOnSignIn()
                    print(error)
                    return
                }
                else {
                    if let currentUser = Auth.auth().currentUser {
                        print(currentUser)
                        self.handleUserLoggedIn(user: currentUser)
                    }
                }
            }
            
        case .failed(let error):
            print("Failed")
            print(error)
             handleErrorOnSignIn()
        case .cancelled:
            print("Cancelled")
             handleErrorOnSignIn()
        }
    }
    
    
    func handleErrorOnSignIn() {
        print("Error happens")
    }
    
    func handleUserLoggedIn(user: User) {
        FirebaseManager.shared.existUser(user, completion: { (userExist) in
            if userExist == false {
                FirebaseManager.shared.createUser(user, success: {
                    print("Registration Done")
                    
                }, failure: { (error) in
                    print("Error when trying to register user")
                    print("Error Message: \(error.debugDescription)")
                })
            }
            
            // Go to Main View
            self.performSegue(withIdentifier: "showMainStoryboardId", sender: self)
        })
    }
   
}
