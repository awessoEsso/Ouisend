//
//  FirebaseManager+Channel.swift
//  Ouisend
//
//  Created by Esso Awesso on 30/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation
import Firebase
import SwiftDate

extension FirebaseManager {
    
    func myChannels(_ success: @escaping (([Channel]) -> Void), failure: ((Error?) -> Void)?) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        let taskGroup = DispatchGroup()
        let queue = DispatchQueue.global()
        var channels = [Channel]()
        let userIdentifier = currentUser.uid
        
        taskGroup.enter()
        joinUsersReference.child(userIdentifier).child("channels").queryOrderedByValue().observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the channel noeud
                dictionary?.forEach {
                    let channelIdentifier = $0.key
                    let participantId = self.getOtherParticipantWithChannelId(channelIdentifier, currentUserIdentifier: userIdentifier)
                    let unread = $0.value as? Int ?? 0
                    taskGroup.enter()
                    self.user(with: participantId, success: { (birder) in
                        taskGroup.enter()
                        self.messages(of: channelIdentifier, success: { (messages) in
                            let channel = Channel(identifier: channelIdentifier, participant: birder, messages: messages, unreadCount: unread)
                            channels.append(channel)
                            taskGroup.leave()
                        }, failure: { (error) in
                            failure?(error)
                            taskGroup.leave()
                        })
                        taskGroup.leave()
                    }, failure: { (error) in
                        failure?(error)
                        taskGroup.leave()
                    })
                }
            }
            taskGroup.leave()
        })
        
        taskGroup.notify(queue: queue) {
            if channels.count > 1 {
                channels = channels.sorted(by: {$0.messages.last!.sentDate.isAfterDate($1.messages.last!.sentDate, granularity: Calendar.Component.nanosecond)  })
            }
            success(channels)
        }
    }
    
    func myChannelsUnreadCount(_ success: @escaping ((Int) -> Void), failure: ((Error?) -> Void)?) {
        guard let currentUser = Auth.auth().currentUser else {
            let error = NSError(domain: "user not loggedIn", code: 3001, userInfo: nil)
            failure?(error)
            return
        }
        let userIdentifier = currentUser.uid
        var unreadCount = 0
        joinUsersReference.child(userIdentifier).child("channels").observe(.value, with: { (snapshot) in
            unreadCount = 0
            if snapshot.childrenCount > 0 {
                let dictionary = snapshot.value as? [String: Any]
                // for each identifier we get the channel noeud
                dictionary?.forEach {
                    let unread = $0.value as? Int ?? 0
                    unreadCount += unread
                }
            }
            success(unreadCount)
        })
    }
    
    private func getOtherParticipantWithChannelId(_ channelId: String, currentUserIdentifier: String) -> String {
        var otherParticipantId = ""
        let participants = channelId.split(separator: "-")
        participants.forEach { (participantId) in
            if participantId != currentUserIdentifier {
                otherParticipantId = String(participantId)
            }
        }
        return otherParticipantId
    }
    
}
