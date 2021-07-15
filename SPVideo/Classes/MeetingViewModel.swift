//
//  MeetingViewModel.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation
import UIKit

final class MeetingViewModel: NSObject,
                              UICollectionViewDataSource,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout {
    
    var peerList = [Peer]()

    private(set) var hms: HMSInteractor!

    private weak var collectionView: UICollectionView?

    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 4.0, bottom: 2.0, right: 4.0)

    // MARK: - Initializers

    init(_ user: String, _ room: String, _ flow: MeetingFlow, _ collectionView: UICollectionView, _ camerapos: String) {

        super.init()

        hms = HMSInteractor(for: user, in: room, flow) { [weak self] state in
            self?.updateView(for: state)
        }

        setup(collectionView)

        observeUserActions()
        
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setup(_ collectionView: UICollectionView) {

        collectionView.dataSource = self
        collectionView.delegate = self

        self.collectionView = collectionView
    }

    private func observeUserActions() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getList(_:)), name: NSNotification.Name(rawValue: "collections"), object: nil)

        _ = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: RoomConstants.updatePinnedView),
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in

            if let indexes = notification.userInfo?[RoomConstants.indexesToBeUpdated] as? [Int] {

                let indexPaths = indexes.map { IndexPath(item: $0, section: 0) }

                self?.collectionView?.reloadItems(at: indexPaths)

                self?.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0),
                                                   at: .left, animated: true)
            }
        }
    }
    
    @objc private func getList(_ notification: NSNotification){
        //print(notification.userInfo ?? "")
                if let dict = notification.userInfo as NSDictionary? {
                    if let peerList = dict["peerlist"] as? [Peer]{
                       // print(#function,peerList.count)
                        self.peerList = peerList
                    }
                }
        var indexes = self.hms.model
            .map({ $0.peer.peerId }) //map the values to the keys
            .map({ secondKey -> Int? in
                return peerList.firstIndex(where:
                                            { $0.peerId == secondKey } //compare the key from your secondArray to the ones in
                )
            })
        
        indexes = indexes.filter { $0 != nil }
        updateViewonIndexes(indexes)
        
        
//        if let row = self.peerList.firstIndex(where: {$0.peerId == model.peer.peerId}) {
//            print("Audio value \(self.peerList[row].isAudio)")
//        }
    }
    
    private func updateViewonIndexes(_ indexes: [Int?]){
        if indexes.count > 0{
            //print("Matching index \(indexes)")
            for index in indexes{
                
                let hmsIndex =  hms.model.firstIndex(where: { $0.peer.peerId == self.peerList[index!].peerId })
                if self.peerList[index!].isAudio == false {
                    if let cell = collectionView?.cellForItem(at: (IndexPath(item: hmsIndex!, section: 0))) as? VideoCollectionViewCell{
                        cell.muteButton.isHidden = false
                    }else{
                        //cell.muteButton.isHidden = true
                    }
                }else{
                    if let cell = collectionView?.cellForItem(at: (IndexPath(item: hmsIndex!, section: 0))) as? VideoCollectionViewCell{
                        cell.muteButton.isHidden = true
                    }
                }
                
                if self.peerList[index!].isVideo == false {
                    if let cell = collectionView?.cellForItem(at: (IndexPath(item: hmsIndex!, section: 0))) as? VideoCollectionViewCell{
                        cell.avatarLabel.isHidden = false
                    }
                }else{
                    if let cell = collectionView?.cellForItem(at: (IndexPath(item: hmsIndex!, section: 0))) as? VideoCollectionViewCell{
                        cell.avatarLabel.isHidden = true
                    }
                }
                
                
            }
            
        }
    }

    // MARK: - View Modifiers

    private func updateView(for state: VideoCellState) {

        print(#function, state)

        switch state {

        case .insert(let index):

            print(#function, index)
            collectionView?.insertItems(at: [IndexPath(item: index, section: 0)])

        case .delete(let index):

            print(#function, index)
            collectionView?.deleteItems(at: [IndexPath(item: index, section: 0)])

        case .refresh(let indexes):

            print(#function, indexes)

        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hms.model.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.resuseIdentifier,
                                                            for: indexPath) as? VideoCollectionViewCell,
               indexPath.item < hms.model.count
        else {
            return UICollectionViewCell()
        }
        
        updateCell(at: indexPath, for: cell)

        return cell
    }

    private func updateCell(at indexPath: IndexPath, for cell: VideoCollectionViewCell) {
        
        

        let model = hms.model[indexPath.row]
        print(#function,"Cell size is \(FirebaseInteractor().peerList.count)")
        
       // _ roomId: String, _ peerId: String, _ streamId: String, _ type: String, _ value : Bool, _ mId: String

        cell.model = model

        cell.videoView.setVideoTrack(model.videoTrack)

        cell.nameLabel.text = model.peer.name

        cell.isSpeaker = model.isCurrentSpeaker

        
        //cell.pinButton.isSelected = model.isPinned

        if let audioEnabled = model.stream.audioTracks?.first?.enabled {
            //cell.muteButton.isSelected = !audioEnabled
            print("Audio enabled value in update cell \(audioEnabled)")
        }

        if let videoEnabled = model.stream.videoTracks?.first?.enabled {
            //cell.stopVideoButton.isSelected = !videoEnabled
            cell.avatarLabel.isHidden = videoEnabled
        } else {
            cell.avatarLabel.isHidden = false
            //cell.stopVideoButton.isSelected = true
        }
        

        cell.avatarLabel.text = Utilities.getAvatarName(from: model.peer.name)
        cell.avatarLabel_top.text = Utilities.getAvatarName(from: model.peer.name)
        
        
        
        print(#function,"update cell called")
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let widthInsets = sectionInsets.left + sectionInsets.right
        let heightInsets = sectionInsets.top + sectionInsets.bottom

        print(#function, "all sizes \(collectionView.frame.size.width - widthInsets) height \((collectionView.frame.size.height / CGFloat(hms.model.count)) - heightInsets) widthinsets \(widthInsets) heightinsets\(heightInsets)")

        let model = hms.model[indexPath.item]

        if model.isPinned {
            return CGSize(width: collectionView.frame.size.width - widthInsets,
                          height: collectionView.frame.size.height - heightInsets)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loaded"), object: nil)
        
        if hms.model.count < 4 {
            let count = CGFloat(hms.model.count)
            return CGSize(width: collectionView.frame.size.width - widthInsets,
                          height: (collectionView.frame.size.height / count) - heightInsets)
        } else {
            let rows = UserDefaults.standard.object(forKey: RoomConstants.maximumRows) as? CGFloat ?? 2.0
            return CGSize(width: (collectionView.frame.size.width / 2) - widthInsets,
                          height: (collectionView.frame.size.height / rows) - heightInsets)
        }
      
        
    }

    // MARK: - Action Handlers

    func cleanup() {
        hms.cleanup()
    }

    func switchCamera() {
        hms.localStream?.videoCapturer?.switchCamera()
    }

    func switchAudio(isOn: Bool) {
        if let audioTrack = hms.localStream?.audioTracks?.first {
            audioTrack.enabled = isOn
        }
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RoomConstants.peerAudioToggled), object: nil)
       // print(#function, )
        
        FirebaseInteractor().getDocument(UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String, UserDefaults.standard.value(forKey: Constants.peerId) as! String,UserDefaults.standard.value(forKey: Constants.streamId) as! String,"audio",isOn,UserDefaults.standard.value(forKey: Constants.mid) as! String)
        
    }

    func switchVideo(isOn: Bool) {
        if let videoTrack = hms.localStream?.videoTracks?.first {
            videoTrack.enabled = isOn
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RoomConstants.peerVideoToggled), object: nil)
        print(#function, isOn, hms.localStream?.videoTracks?.first?.enabled as Any)
        
        FirebaseInteractor().getDocument(UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String, UserDefaults.standard.value(forKey: Constants.peerId) as! String,UserDefaults.standard.value(forKey: Constants.streamId) as! String,"video",isOn,UserDefaults.standard.value(forKey: Constants.mid) as! String)
    }

    func sendMessage(_ message: String){
        hms.send(["sender":hms.localPeer.peerId,"receiver": UserDefaults.standard.value(forKey: Constants.defaultName) as! String, "time": Utilities.getTimeStamp(), "type": "chat","message": message], completion: { isSend,error in
            if isSend == true{
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RoomConstants.broadcastReceived), object: nil,userInfo: ["name": UserDefaults.standard.value(forKey: Constants.defaultName) as! String,"message": message,"timestamp" : Utilities.getTimeStamp() as String])
             
        }
        })
    }
    
    func sendFeedBack(_ view: UIView,_ rating: Int, _ feedBack : String){
        let indicatorView = IndicatorView(text: "Sending Feedback")
        view.addSubview(indicatorView)
        
        guard let serviceUrl = URL(string: String(format: RoomConstants.feedbackUrl)) else { return }
            let parameters: [String: Any] = [
                "meetingId" : (UserDefaults.standard.object(forKey: RoomConstants.roomIDKey) as? String ?? "") as String,
                "userId"    : (UserDefaults.standard.object(forKey: RoomConstants.userIdKey) as? String ?? "") as String,
                "rating" : rating as Int,
                "feedback" : feedBack as String
            ]
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
                return
            }
            request.httpBody = httpBody
            request.timeoutInterval = 20
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(#function,"Response is \(response)")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: RoomConstants.feedbackSent), object: nil)
                    indicatorView.hide()
                }
                if let data = data {
                    indicatorView.hide()
                    do {
                        let json = try JSONSerialization.jsonObject(with: data,
                                                                       options: .mutableContainers) as? [String: Any]
                        if let value = json?["result"] as? String {
                            print(#function,"Send feedback response is \(value)")
                            self.cleanup()
                        }
                        
                    } catch {
                        print(#function,error)
                    }
                }
            }.resume()
        }
 }
