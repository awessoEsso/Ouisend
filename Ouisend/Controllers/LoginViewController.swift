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
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
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
            
            
             getUserProfile()
            
            
            
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
    
    private func getUserProfile() {
        let connection = GraphRequestConnection()
        connection.add(MyProfileRequest()) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
//                print("My facebook id is \(response.dictionaryValue?["id"])")
//                print("My name is \(response.dictionaryValue?["name"])")
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        connection.start()
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
            
            let _ = Datas.shared.countries
        })
    }
   
}



struct MyProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        init(rawResponse: Any?) {
            // Decode JSON from rawResponse into other properties here.
        }
    }
    
    var graphPath = "/me"
    var parameters: [String : Any]? = ["fields": "id, name"]
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
}
