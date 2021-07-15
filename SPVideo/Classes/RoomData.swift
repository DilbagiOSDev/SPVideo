//
//  RoomData.swift
//  SampleFramework
//
//  Created by Gowthaman G on 03/07/21.
//

import Foundation

class RoomData : NSObject,NSCoding,Decodable {
    
    var teamName,teamLogo,room,token,username,callToken,chatToken,chatAppId,platform : String!
    var status : Bool!
    var locked : Int!
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.status = decoder.decodeBool(forKey: "status")
        self.teamName = decoder.decodeObject(forKey: "teamName") as? String
        self.teamLogo = decoder.decodeObject(forKey: "teamLogo") as? String
        self.room = decoder.decodeObject(forKey: "room") as? String
        self.token = decoder.decodeObject(forKey: "token") as? String
        self.username = decoder.decodeObject(forKey: "username") as? String
        self.callToken = decoder.decodeObject(forKey: "callToken") as? String
        self.chatToken = decoder.decodeObject(forKey: "chatToken") as? String
        self.chatAppId = decoder.decodeObject(forKey: "chatAppId") as? String
        self.platform = decoder.decodeObject(forKey: "platform") as? String
        self.locked = decoder.decodeInteger(forKey: "locked")
    }
    
    convenience init(status: Bool,teamName: String,teamLogo: String,room: String,token: String,username: String,callToken: String,chatToken: String,chatAppId: String,platform: String, locked: Int) {
        self.init()
        self.status = status
        self.teamName = teamName
        self.teamLogo = teamLogo
        self.room = room
        self.token = token
        self.username = username
        self.callToken = callToken
        self.chatToken = chatToken
        self.chatAppId = chatAppId
        self.platform = platform
        self.locked = locked
        
    }
    
    func encode(with aCoder: NSCoder) {
        if let status = status { aCoder.encode(status, forKey: "status") }
        if let teamName = teamName { aCoder.encode(teamName, forKey: "teamName") }
        if let teamLogo = teamLogo { aCoder.encode(teamLogo, forKey: "teamLogo") }
        if let room = room { aCoder.encode(room, forKey: "room") }
        if let token = token { aCoder.encode(token, forKey: "token") }
        if let username = username { aCoder.encode(username, forKey: "username") }
        if let callToken = callToken { aCoder.encode(callToken, forKey: "callToken") }
        if let chatToken = chatToken { aCoder.encode(chatToken, forKey: "chatToken") }
        if let chatAppId = chatAppId { aCoder.encode(chatAppId, forKey: "chatAppId") }
        if let platform = platform { aCoder.encode(platform, forKey: "platform") }
        if let locked = locked { aCoder.encode(locked, forKey: "locked") }
        
    }
    
}
