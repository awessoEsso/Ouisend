//
//  FirebaseManager+Message.swift
//  Ouisend
//
//  Created by Esso Awesso on 16/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

import FirebaseDatabase

extension FirebaseManager {
    func createMessage(_  message: OuiMessage, to: String) {
        guard let birder = Datas.shared.birder else { return }
        let channel = channelForUsers(userIds: [birder.identifier, to])
        let reference = channelReference.child(channel).child("messages").childByAutoId()
        var newMessage = [
            "created": ServerValue.timestamp(),
            "senderID": message.sender.id,
            "senderName": message.sender.displayName,
            "content": "Message text"
            ] as [String: Any]
        
        switch message.kind {
        case .text(let text), .emoji(let text):
            newMessage["content"] = text
        case .attributedText(let text):
            newMessage["content"] = text
        default:
            break
        }
        
        reference.setValue(newMessage)
        
        incrementUnreadFor(to: to, channel: channel)
        
        FirebaseManager.shared.tokenForUser(with: to, success: { (destinataireToken) in
            let message = "You received a message from: \(birder.displayName ?? "a birder")"
            FirebaseManager.shared.createMessageNotification(message, senderId: birder.identifier, token: destinataireToken)
        }) { (error) in
            print(error?.localizedDescription ?? "Error getting Request creator token")
        }
    }
    
    private func incrementUnreadFor(to: String, channel: String) {
        joinUsersReference.child(to).child("channels").child(channel).observeSingleEvent(of: .value) { (snapshot) in
            let unread = snapshot.value as? Int ?? 0
            self.joinUsersReference.child(to).child("channels").child(channel).setValue(unread + 1)
        }
    }
    
    func resetUnreadForChannel(_ channel: String) {
        guard let birder = Datas.shared.birder else { return }
        self.joinUsersReference.child(birder.identifier).child("channels").child(channel).setValue(0)
    }
    
    
    func messagesByChild(of channel: String, success: @escaping ((OuiMessage) -> Void), failure: ((Error?) -> Void)?) {
        channelReference.child(channel).child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = OuiMessage(identifier: snapshot.key, dictionary: dictionary)
                success(message)
            } else {
                failure?(nil)
            }
        })
    }
    
    
    
    func messages(of channel: String, success: @escaping (([OuiMessage]) -> Void), failure: ((Error?) -> Void)?) {
        channelReference.child(channel).child("messages").observeSingleEvent(of:.value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                guard let dictionary = snapshot.value as? [String: Any] else {
                    let anError = NSError(domain: "error occured: can't retreive channel messages", code: 30001, userInfo: nil)
                    failure?(anError)
                    return
                }
                var messages = [OuiMessage]()
                for (key, item) in dictionary {
                    if let dict = item as? [String: Any] {
                        let message = OuiMessage(identifier: key, dictionary: dict)
                        messages.append(message)
                    }
                }
                messages.sort(by: { (m1, m2) -> Bool in
                    return m1.sentDate < m2.sentDate
                })
                success(messages)
            }
            else {
                // Return empty list
                success([OuiMessage]())
            }
        })
    }
    
    
    func channelForUsers(userIds: [String]) -> String {
        var channel: String = ""
        if userIds.count == 2 {
            let ids = userIds.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
            channel = "\(ids[0])-\(ids[1])"
        }
        return channel.replacingOccurrences(of: " ", with: "")
    }
    
    
}
