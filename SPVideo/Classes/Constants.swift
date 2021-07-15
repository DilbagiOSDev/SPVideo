//
//  Constants.swift
//  SampleFrameworkTests
//
//  Created by Gowthaman G on 02/07/21.
//

import Foundation
import UIKit

internal struct Constants {

    static let bundleId : String                    =  "com.superpro.VideoCall-IOS"
    static let landscene: String                    = "LandScene"
    static let setup : String                       = "Setup"
    static let meeting : String                     = "Meeting"
    static let defaultName: String                  = "DefaultName"
    static let roomName: String                     = "RoomName"
    static let role : String                        = "role"
    static let flow : String                        = "flow"
    static let publishAudio : String                = "Audio"
    static let publishVideo : String                = "Video"
    static let resuseIdentifier                     = "VideoCollectionViewCell"
    static let cameraPos                            = "CameraPos"
    static var agora_appID                          = "chatappId"
    static var agora_temp_token                     = "chattoken"
    static var peerId                               = "peerId"
    static var streamId                             = "streamId"
    static var documentID                           = "documentId"
    static var mid                                  = "mid"
    static var baseUrl                              = "https://apidev.superpro.ai/"
    //calldevapi.superpro.ai   apidev.superpro.ai
    // MARK: New defaults
   // let meetingId                                    = "b43-3795-188"
    let meetingId                                    = "meetingId"
    let locked                                       = "locked"
    //let token                                        = "token"
    let token                                        = "token"
    let privacyValue                                 = "privacyval"
   
   // let getMeetinPrivacyUrl                          = "https://calldevapi.superpro.ai/v0/meeting/"
    let getMeetinPrivacyUrl                          = "v0/meeting/"
    let joinRoomUrl                                  = "v0/rooms/join"
    let segmentKey                                   = "zIw8UbWEnOha7iInA5oSUQDyC0FHlOru"
    let joinOpenMeetUrl                              = "v0/meeting/"
    
    
}

internal struct SetupConstants {
    static var audioOptions:[String] = ["Default", "Speakerphone", "Headset earpiece"]
    static var videoOptions = ["camera 1, facing front", "camera 2, facing back",""]
}

internal struct RoomConstants{
    
    static var feedbackUrl                          = "https://roomsvc-dot-sprpro-282209.el.r.appspot.com//vcrating"
    static var managementToken                      = "managementtoken"
    static var tokenKey:String                      = "tokenkey"
    static var idKey:String                         = "id"
    static var userIdKey                            = "user"
    static var hmsError:String                      = "HMS Error"
    static var endPoint                             = "wss://prod-in.100ms.live/ws"
    static var roomIDKey                            = "roomID"
    static var audioPollDelay                       = "audioPollDelay"
    static var peersUpdated                         = "peersUpdated"
    static var broadcastReceived                    = "broadcastReceived"
    static var videoBitRate                         = "videoBitRate"
    static var audioBitRate                         = "audioBitRate"
    static var videoFrameRate                       = "videoFrameRate"
    static var defaultVideoSource                   = "defaultVideoSource"
    static var settingsUpdated                      = "settingsUpdated"
    static var pinTapped                            = "pinTapped"
    static var peerID                               = "peerID"
    static var updatePinnedView                     = "updatePinnedView"
    static var indexesToBeUpdated                   = "indexesToBeUpdated"
    static var videoCodec                           = "videoCodec"
    static var videoResolution                      = "videoResolution"
    static var muteALL                              = "muteALL"
    static var peerAudioToggled                     = "peerAudioToggled"
    static var peerVideoToggled                     = "peerVideoToggled"
    static var maximumRows                          = "maximumRows"
    static var feedbackSent                         = "feedbackSent"
    
}

struct ViewControllers {
    static var landscenevc                          = "LandSceneViewController"
    static var launchvc                             = "LaunchViewController"
    static var setupvc                              = "SetupViewController"
    static var meetingvc                            = "MeetingViewController"
    
    //MARK:collectionviews
    static var setupcell                            = "SetupOptionsTableViewCell"
    static var chatmessageCell                      = "ChatMessageTableViewCell"
}
