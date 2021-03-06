//
//  FirebaseManager+Notification.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension FirebaseManager {
    func createNotification(_  message: String) {
        let reference = notificationReference.childByAutoId()
        let newNotification = [
            "message": message,
            "sent": false,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "attempts": 0
            ] as [String: Any]
        reference.setValue(newNotification)
    }
    
    func createTopicNotification(_  message: String, topic: String) {
        let reference = topicNotificationReference.childByAutoId()
        let newNotification = [
            "message": message,
            "topic": topic,
            "sent": false,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "attempts": 0
            ] as [String: Any]
        reference.setValue(newNotification) { (error, ref) in
            if let error = error {
                print(error.localizedDescription )
            }
        }
    }
    
    func createTopicNotificationForBird(_ bird: Bird, topic: String) {
        let reference = topicNotificationReference.childByAutoId()
        let message = "Bird de \(bird.birdWeight) Kg dispo pour \(bird.departureCity) - \(bird.arrivalCity)"
        let newNotification = [
            "message": message,
            "topic": topic,
            "sent": false,
            "birdId": bird.identifier,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "attempts": 0
            ] as [String: Any]
        reference.setValue(newNotification) { (error, ref) in
            if let error = error {
                print(error.localizedDescription )
            }
        }
    }
    
    func createOneToOneNotification(_  message: String, token: String) {
        let reference = oneToOneNotificationReference.childByAutoId()
        let newNotification = [
            "message": message,
            "to": token,
            "sent": false,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "attempts": 0
            ] as [String: Any]
        reference.setValue(newNotification)
    }
    
    func createMessageNotification(_  message: String, senderId: String, token: String) {
        let reference = oneToOneNotificationReference.childByAutoId()
        let newNotification = [
            "message": message,
            "to": token,
            "sent": false,
            "senderId": senderId,
            "createdAt": ServerValue.timestamp(),
            "updatedAt": ServerValue.timestamp(),
            "attempts": 0
            ] as [String: Any]
        reference.setValue(newNotification)
    }
}
