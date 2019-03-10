//
//  FirebaseManager+Messaging.swift
//  Ouisend
//
//  Created by Esso Awesso on 06/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import FirebaseMessaging


enum SubscriptionTopic: String {
    case notifications = "NotificationsTopic"
}

class FIRMessagingService {
    
    private init() {}
    static let shared = FIRMessagingService()
    let messaging = Messaging.messaging()
    
    func subscribe(to topic: SubscriptionTopic) {
        messaging.subscribe(toTopic: topic.rawValue)
    }
    
    func subscribe(to city: String) {
        messaging.subscribe(toTopic: city)
    }
    
    func unsubscribe(from city: String) {
        messaging.unsubscribe(fromTopic: city)
    }
}

