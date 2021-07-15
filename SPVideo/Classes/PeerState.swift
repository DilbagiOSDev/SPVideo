//
//  PeerState.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation
import HMSVideo

final class PeerState {

    let peer: HMSPeer

    let stream: HMSStream

    let videoTrack: HMSVideoTrack?

    var isCurrentSpeaker = false

    var isPinned = false
    
    var audioEnabled = false
    var videoEnabled = false

    
    init(_ peer: HMSPeer, _ stream: HMSStream, _ videoTrack: HMSVideoTrack?) {
        self.peer = peer
        self.stream = stream
        self.videoTrack = videoTrack
        
    }
}
