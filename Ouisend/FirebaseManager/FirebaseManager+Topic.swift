//
//  FirebaseManager+Topic.swift
//  Ouisend
//
//  Created by Esso Awesso on 09/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase

extension FirebaseManager {
    func createTopic(_ identifier: String, departureCity: String, arrivalCity: String, creator: String, success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let reference = topicReference.child(identifier)
        let newTopic = [
            "createdAt": ServerValue.timestamp(),
            ] as [String: Any]
        reference.setValue(newTopic) { (error, reference) in
            if error == nil {
                self.createTopicJoinReference( identifier, departureCity: departureCity, creator: creator, arrivalCity: arrivalCity, success: {
                    success?()
                }, failure: { (error) in
                    failure?(error)
                })
            }
            else {
                failure?(error)
            }
        }
    }
    
    func deleteTopic(identifier: String, for userId: String) {
        joinUsersReference.child(userId).child("topics").child(identifier).removeValue()
    }
    
    fileprivate func createTopicJoinReference(_ identifier: String, departureCity: String, creator: String, arrivalCity: String,  success: (() -> Void)?, failure: ((Error?) -> Void)?) {
        let route = "\(departureCity) - \(arrivalCity)"
        joinUsersReference.child(creator).child("topics").child(identifier).setValue(route) { (error, reference) in
            if (error == nil) {
                success?()
            }
            else {
                failure?(error)
            }
        }
    }
    
    func myTopics(_ success: @escaping (([TopicJoin]) -> Void), failure: ((Error?) -> Void)?) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        var topicJoins = [TopicJoin]()
        let userIdentifier = currentUser.uid
    joinUsersReference.child(userIdentifier).child("topics").queryOrderedByValue().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the topic noeud
                dictionary?.forEach {
                    let topicIdentifier = $0.key
                    let topicName = $0.value as? String ?? ""
                    let topicJoin = TopicJoin(identifier: topicIdentifier, name: topicName)
                    topicJoins.append(topicJoin)
                }
                success(topicJoins)
            }
            else {
                success(topicJoins)
            }
        })
    }
    
}
