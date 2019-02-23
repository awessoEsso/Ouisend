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
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        
        view.addSubview(loginButton)
        
    }

}


extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did Logout")
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print(result)
        
        switch result {
        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
            print("Success")
            let credentials = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
            
            Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
                if let error = error {
                    // ...
                    return
                }
                
                if let currentUser = Auth.auth().currentUser {
                    print(currentUser)
                }
            }
            
        case .failed(let error):
            print("Failed")
        case .cancelled:
            print("Cancelled")
        default:
            print("toto")
        }
    }
}

//struct MyProfileRequest: GraphRequestProtocol {
//    struct Response: GraphResponseProtocol {
//        init(rawResponse: Any?) {
//            // Decode JSON from rawResponse into other properties here.
//            print(rawResponse)
//        }
//    }
//
//    var graphPath = "/me"
//    var parameters: [String : Any]? = ["fields": "id, name, link"]
//    var accessToken = AccessToken.current
//    var httpMethod: GraphRequestHTTPMethod = .GET
//    var apiVersion: GraphAPIVersion = .defaultVersion
//}
//
//struct MyCustomRequest: GraphRequestProtocol {
//    struct Response: GraphResponseProtocol {
//        init(rawResponse: Any?) {
//            // Decode JSON from rawResponse into other properties here.
//            print(rawResponse)
//        }
//    }
//
//    var graphPath = "/me"
//    var parameters: [String : Any]? = ["fields": "profile_pic"]
//    var accessToken = AccessToken.current
//    var httpMethod: GraphRequestHTTPMethod = .GET
//    var apiVersion: GraphAPIVersion = .defaultVersion
//
//    init(path: String, parameters: [String : Any]?) {
//        self.graphPath = path
//        self.parameters = parameters
//    }
//



