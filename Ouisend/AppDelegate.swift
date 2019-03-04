//
//  AppDelegate.swift
//  Ouisend
//
//  Created by Esso Awesso on 22/02/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])

        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        setRootViewControllerIfNotLoggedIn()
        
        let _ = Datas.shared.countries
        
        
        return true
    }
    
    func setRootViewControllerIfNotLoggedIn() {
        // Check if logged In
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            let loginViewController = UIStoryboard.loginViewController()
            window?.rootViewController = loginViewController
        }
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }


}

