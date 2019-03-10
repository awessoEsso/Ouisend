//
//  Topic.swift
//  Ouisend
//
//  Created by Esso Awesso on 09/03/2019.
//  Copyright © 2019 Esso Awesso. All rights reserved.
//

import Foundation

class Topic {
    
    internal(set) var identifier: String

    init(identifier anIdentifier: String) {
        self.identifier = anIdentifier
    }
}


class TopicJoin {
    
    internal(set) var identifier: String
    internal(set) var name: String
    
    init(identifier : String, name: String) {
        self.identifier = identifier
        self.name = name
    }
}

