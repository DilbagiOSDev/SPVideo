//
//  Peer.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation

final class Peer : Codable{
    let peerId: String!

    let isAudio: Bool!

    let isVideo: Bool!
    
    init(_ peerId: String, _ isAudio: Bool! ,_ isVideo: Bool ) {
        self.peerId = peerId
        self.isAudio = isAudio
        self.isVideo = isVideo
    }
}
