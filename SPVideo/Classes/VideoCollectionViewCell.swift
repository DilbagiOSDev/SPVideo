//
//  VideoCollectionViewCell.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation
import HMSVideo
import QuartzCore

//@IBOutlet weak var pinButton: UIButton!
//@IBOutlet weak var stopVideoButton: UIButton!

final class VideoCollectionViewCell: UICollectionViewCell {

    weak var model: PeerState?

//    @IBOutlet weak var stackView: UIStackView! {
//        didSet {
//            //Utilities.applyBorder(on: stackView)
////            stackView.backgroundColor = stackView.backgroundColor?.withAlphaComponent(0.5)
//        }
//    }

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var muteButton: UIButton!

    @IBOutlet weak var videoView: HMSVideoView!

    @IBOutlet weak var avatarLabel: UILabel! {
        didSet {
            avatarLabel.layer.cornerRadius = 54
        }
    }
    @IBOutlet weak var avatarLabel_top: UILabel!{
        didSet {
            
            avatarLabel_top.layer.cornerRadius = 10
            avatarLabel_top.layer.borderWidth = 1
        }
    }
    
    var isSpeaker = false {
        didSet {
            if isSpeaker {
                Utilities.applySpeakerBorder(on: videoView)
            } else {
                Utilities.applyBorder(on: videoView)
            }
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)


        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RoomConstants.peerVideoToggled),
                                                   object: nil,
                                                   queue: .main) { [weak self] _ in
            if let videoEnabled = self?.model?.stream.videoTracks?.first?.enabled {
//                self?.stopVideoButton.isSelected = !videoEnabled
                self?.avatarLabel.isHidden = videoEnabled
                print("Video enabled vaule is \(RoomConstants.peerVideoToggled)")
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

//    @IBAction func pinTapped(_ sender: UIButton) {
//        print(#function, sender.isSelected, model?.peer.name as Any)
//        sender.isSelected = !sender.isSelected
//        model?.isPinned = sender.isSelected
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RoomConstants.pinTapped),
//                                        object: nil,
//                                        userInfo: [RoomConstants.peerID: model?.peer.peerId as Any])
//    }

    @IBAction func muteTapped(_ sender: UIButton) {
        print(#function, sender.isSelected, model?.peer.name as Any)
        model?.stream.audioTracks?.first?.enabled = sender.isSelected
        sender.isSelected = !sender.isSelected
        
        
    }
}
