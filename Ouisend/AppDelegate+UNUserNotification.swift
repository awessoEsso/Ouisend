//
//  AppDelegate+UNUserNotification.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotification(for: response)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("un will present")
        print(notification.request.content.userInfo)
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
    
    
    
    func handleNotification(for response: UNNotificationResponse) {
        let content = response.notification.request.content
        let body = content.body
        if body.contains("You received a message from:") {
            guard let senderId = content.userInfo["senderId"] as? String else { return }
            FirebaseManager.shared.user(with: senderId, success: { (sender) in
                
                let chatViewController = UIStoryboard.chatViewController() as! UINavigationController
                if let ouiChatViewController = chatViewController.viewControllers.first as? OuiChatViewController {
                    ouiChatViewController.destinataire = sender
                    ouiChatViewController.destinataireId = sender.identifier
                    ouiChatViewController.destinataireName = sender.displayName ?? ""
                    ouiChatViewController.destinataireUrl = sender.photoURL ?? URL(string: "")!
                    ouiChatViewController.isRoot = true
                    PresenterController.shared?.show(controller: chatViewController, animated: true)
                }
                
            }) { (error) in
                print(error?.localizedDescription ?? "Error getting user informations")
            }
        }
        else if body.contains("Bird de ") {
            guard let birdId = content.userInfo["birdId"] as? String else { return }
            UserDefaults.init().set(birdId, forKey: "showBirdId")
            let homeController = UIStoryboard.homeTabBarController() as! UITabBarController
            PresenterController.shared?.show(controller: homeController, animated: true)
        }
        
        
    }
    
}
