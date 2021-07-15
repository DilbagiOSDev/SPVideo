//
//  SenderType.swift
//  SampleFramework
//
//  Created by Gowthaman G on 03/07/21.
//

import Foundation

public protocol SenderType {

    /// The unique String identifier for the sender.
    ///
    /// Note: This value must be unique across all senders.
    var senderId: String { get }

    /// The display name of a sender.
    var displayName: String { get }
}
