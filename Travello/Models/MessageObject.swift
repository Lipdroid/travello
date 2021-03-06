//
//  MessageObject.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/14/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation

class MessageObject{
    var idSender: String!
    var idReceiver: String!
    var timestamp: Double!
    var text: String!
    
    init(idSender: String,idReceiver: String,timestamp: Double,text: String) {
        self.idSender = idSender
        self.idReceiver = idReceiver
        self.timestamp = timestamp
        self.text = text
    }
}
