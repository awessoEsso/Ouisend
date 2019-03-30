//
//  Channel.swift
//  Ouisend
//
//  Created by Esso Awesso on 30/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation


class Channel {
    
    internal(set) var identifier: String
    internal(set) var participant: Birder
    internal(set) var messages: [OuiMessage]
    internal(set) var unreadCount: Int
    
    init(identifier anIdentifier: String, participant: Birder, messages: [OuiMessage], unreadCount: Int) {
        self.identifier = anIdentifier
        self.participant = participant
        self.messages = messages
        self.unreadCount = unreadCount
    }
}
