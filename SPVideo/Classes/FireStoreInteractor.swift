//
//  FireStoreInteractor.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation
import FirebaseFirestore
import UIKit

public class FirebaseInteractor {
    var db: Firestore!
    var peerList = [Peer]()
    
    let settings = FirestoreSettings()
    
    func setup(){
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func addUsers(_ value: [String:Any], _ roomId: String, _ peerId: String, _ publisher: String,_ mId: String){
        
        var ref: DocumentReference? = nil
        
        let midData = [mId: ["audioEnabled": true as Bool,"uid": peerId,"videoEnabled": true as Bool, "timestamp": Utilities.getDate() as String]] as [String : [String : Any]]
        let streamData = ["streams": midData]
        ref = Firestore.firestore().collection("meetingRooms").document(roomId).collection("peers").document(peerId)
        ref?.setData(streamData){
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                if publisher == "publish"{
                    UserDefaults.standard.setValue(ref!.documentID, forKey: Constants.documentID)
                }
                
                print("Document added with ID: \(ref!.documentID) peer id is \(roomId)")
            }
        }
        
    }
    
    func getDocument(_ roomId: String, _ peerId: String, _ streamId: String, _ type: String, _ value : Bool, _ mId: String){
        
        let docRef = Firestore.firestore().collection("meetingRooms").document(roomId).collection("peers").document(peerId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var midData = [String: [String: Any]]()
                if type == "audio" {
                    midData = [mId: ["audioEnabled": value as Bool] ]
                    docRef.setData(["streams": midData], merge: true)
                }else if type == "video"{
                    midData = [mId: ["videoEnabled": value as Bool] ]
                    docRef.setData(["streams": midData], merge: true)
                }
               
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func listenWithMetadata(_ roomId: String) {
        print(#function,roomId)
        if self.peerList.count > 0{
            self.peerList.removeAll()
        }
        Firestore.firestore().collection("meetingRooms").document(roomId).collection("peers")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                for document in document.documents {
                    
                    if let streams = document.data()["streams"] as? [String:Any]{
                        let keys: [String] = streams.map({ $0.key})
                        print("All collection : \(streams)")
                        for key in keys{
                            if let peerData = streams[key] as? [String:Any]{
                                let peer = Peer(peerData["uid"] as? String ?? "" , (peerData["audioEnabled"] as? Bool ?? false), peerData["videoEnabled"] as? Bool ?? false)
                                let peerIndex = self.peerList.firstIndex(where:{ $0.peerId == peer.peerId})
                                if peerIndex == nil {
                                    self.peerList.append(peer)
                                }else{
                                    self.peerList[peerIndex!] = peer
                                    
                                }
                                
                            }
                        }
                                    
                    }

                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "collections"), object: nil, userInfo: ["peerlist":self.peerList])
            }
    }

    func removeUser(_ peerId: String){
        Firestore.firestore().collection("meetingRooms").document(UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String).collection("peers").document(peerId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }

        }
        
        let listener = Firestore.firestore().collection("meetingRooms").document(UserDefaults.standard.value(forKey: RoomConstants.roomIDKey) as! String).collection("peers")
            .addSnapshotListener { querySnapshot, error in
        }

        listener.remove()
    }
    
}
