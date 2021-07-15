//
//  ExternalInputData.swift
//  VideoFramework
//
//  Created by Gowthaman G on 08/07/21.
//


public class ExternalInputData  {
    public init() {
        
    }
    public func setData(username: String, meetingId: String, token: String? = nil) {
        InputData.sharedInstance.setData(username: username, meetingId: meetingId, token: token)
    }
}
