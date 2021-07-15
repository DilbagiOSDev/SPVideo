//
//  RoomService.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import Foundation

struct RoomService {
    
    // MARK: - Join Room
    
    static func getRoomPrivacy(_ roomId: String, completion: @escaping (Int?, String?,RoomData?) -> Void) {
        if let request = getRoomPrivacyRequest(for: "\(Constants.baseUrl)\(Constants().getMeetinPrivacyUrl)\(roomId)/privacy", for: "privacy") {
            URLSession.shared.dataTask(with: request) { data, response, error in

                guard error == nil, response != nil, let data = data else {
                    print(#function, error?.localizedDescription ?? "Unexpected Error")
                    completion(nil, error?.localizedDescription ?? "No response", nil)
                    return
                }
                

                let (parsedData, error,object) = getRoomParse(data, for: Constants().locked,"privacy")
                print("Get room privacy \(String(describing: parsedData))")
                completion(parsedData, error?.description,object)
            }.resume()
        }
    }
    
    static func getRoomPrivacyRequest(for url: String, for type: String, for meetId: String? = nil, for token: String? = nil) -> URLRequest? {
        print(#function,"url is \(url) token is \(String(describing: token))")
        guard let url = URL(string: url)
        else {
            print("Error: ", #function, "Endpoint URLs are incorrect")
            return nil
        }
        var request = URLRequest(url: url)
        if type == "join" {
            request.httpMethod = "POST"
            var body = [String: Any]()
            if token == "token" {
                request = URLRequest(url: URL(string: "\(Constants.baseUrl)\(Constants().joinOpenMeetUrl)\(meetId!)/join-open")!)
                request.httpMethod = "POST"
                print(#function, "URL: ", "\(Constants().joinOpenMeetUrl)\(meetId!)/join-open", "\nBody: ", body)
                body = ["name": UserDefaults.standard.value(forKey: Constants.defaultName) as! String,
                         "client": "ios"] as [String : Any]
            }else{
                body = ["meetingId": meetId! as String,
                        "token": token!, "client": "ios"] as [String : Any]
                
            }
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            } catch {
                print("Error: ", #function, "Incorrect body parameters provided")
                print(error.localizedDescription)
            }
        }else{
            request.httpMethod = "GET"
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func getRoomParse(_ data: Data, for key: String, _ type: String) -> (Int?, String?, RoomData?) {
        do {
            let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            print(#function,"Data to dict is \(dict)")
            if let message = dict["message"] {
                return(nil,message as? String,nil)
            }
            if let message = dict["msg"]{
                return(nil,message as? String,nil)
            }
            let object = try DictionaryDecoder().decode(RoomData.self, from: dict)
            print(#function,"room id is \(String(describing: object.room))")
            if type == "join"{
                return(nil, nil,object)
            }else{
                if let locked = dict["locked"] {
                    return(locked as? Int, nil,nil)
                }
            }
        }
        catch{
            print(error)
        }
        let stringInt = String.init(data: data, encoding: String.Encoding.utf8)
        let int = Int.init(stringInt ?? "")
        return (int, nil,nil)
    }
    
    
    static func joinRoom(_ roomId: String,_ token: String? = nil, completion: @escaping (Int?, String?,RoomData?) -> Void) {
        print(#function,"Token is \(token!)")
        if token == "token"{
            if let request = getRoomPrivacyRequest(for: Constants.baseUrl + Constants().joinOpenMeetUrl, for: "join",for: roomId,for: "token") {
                URLSession.shared.dataTask(with: request) { data, response, error in
                   
                    guard error == nil, response != nil, let data = data else {
                        print(#function, error?.localizedDescription ?? "Unexpected Error")
                        completion(nil, error?.localizedDescription ?? "No response",nil)
                        return
                    }
                    
                    let (parsedData, error,object) = getRoomParse(data, for: Constants().locked, "join")
                    print("Join room reponse \(String(describing: parsedData))")
                    completion(parsedData, error?.description, object)
                    
                }.resume()
            }
        }else{
            if let request = getRoomPrivacyRequest(for: Constants.baseUrl + Constants().joinRoomUrl, for: "join",for: roomId,for: token) {
                URLSession.shared.dataTask(with: request) { data, response, error in
                   
                    guard error == nil, response != nil, let data = data else {
                        print(#function, error?.localizedDescription ?? "Unexpected Error")
                        completion(nil, error?.localizedDescription ?? "No response",nil)
                        return
                    }
                    
                    let (parsedData, error,object) = getRoomParse(data, for: Constants().locked, "join")
                    print("Join room reponse \(String(describing: parsedData))")
                    completion(parsedData, error?.description, object)
                    
                }.resume()
            }
        }
        
    }
    
    
}
