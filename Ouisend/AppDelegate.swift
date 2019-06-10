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
import FacebookLogin
import Fabric
import Alamofire
import SwiftyJSON
import ObjectMapper
import Disk
import Crashlytics
import UserNotifications
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        registerRemoteNotifications(application)
        Messaging.messaging().delegate = self
        _ = Datas.shared.cities
        
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: "hasRunBefore") {
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // Forces the app to update UserDefaults
            try? Auth.auth().signOut()
            LoginManager.init().logOut()
        }
        
        if UserDefaults.isFirstLaunch() {
            // Enable Text Messages
            UserDefaults.standard.set(true, forKey: "Text Messages")
            showOnBoarding(window: window)
        }
        else {
            setRootViewControllerIfNotLoggedIn()
        }
        return true
    }
    
    func showOnBoarding(window: UIWindow?) {
        let onBoardingController = UIStoryboard.onBoardingViewController()
        window?.rootViewController = onBoardingController
        window?.makeKeyAndVisible()
    }
    
    func setRootViewControllerIfNotLoggedIn() {
        // Check if logged In
        let currentUser = Auth.auth().currentUser
        if currentUser == nil {
            let loginViewController = UIStoryboard.loginViewController()
            window?.rootViewController = loginViewController
        }
    }
    
    func registerRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return SDKApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
}

