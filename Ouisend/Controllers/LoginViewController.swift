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
import SCLAlertView

let defaults = UserDefaults.standard

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let loginButton = LoginButton(readPermissions: [ .publicProfile, .email ])
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @IBAction func whyFacebookAction(_ sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showInfo("Pourquoi Facebook?", subTitle: "Pour rassurer nos utilisateurs 📦, on a besoin de nous assurer que tu es une vraie personne du monde réel et Facebook Connect fait cela très bien. \n Nous récupérons uniquement votre nom, prénoms, photo de profil et votre adresse email - rien de plus. \n  🤗")
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
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
        SCLAlertView().showError("Error", subTitle: "Error Login User")
    }
    
    func handleUserLoggedIn(user: User) {
        saveUserInUserDefaults(Birder(user: user))
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
    //SKeyedArchiver.archivedData(withRootObject: user)
    func saveUserInUserDefaults(_ birder: Birder) {
        do {
            let birderData = try NSKeyedArchiver.archivedData(withRootObject: birder)
            defaults.set(birderData , forKey: "birder")
        } catch let error {
            print(error)
        }
        
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
