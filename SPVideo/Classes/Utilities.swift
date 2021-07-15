//
//  Utilities.swift
//  SampleFrameworkTests
//
//  Created by Gowthaman G on 03/07/21.
//

import Foundation
import UIKit
import QuartzCore
import SystemConfiguration
import Segment

class Utilities {
  
    static func applyBorder(on view: UIView, radius: CGFloat = 8) {
        view.layer.borderColor = UIColor( red: 0.197, green: 0.197, blue:0.197, alpha: 0.5 ).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
        
    }
    
    static func drawCircle(on view: UIButton) {
        view.clipsToBounds = true
        view.layer.cornerRadius = view.frame.width/2
    }

    static func drawCorner(on view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
    }
    
    static func drawCornerView(on view: Any) {
        (view as AnyObject).layer.cornerRadius = 8
        (view as AnyObject).layer.masksToBounds = true
    }
    

    static func applySpeakerBorder(on view: UIView) {

        if #available(iOS 13.0, *) {
            view.layer.borderColor = UIColor.link.cgColor
        } else {
            view.layer.borderColor = UIColor.blue.cgColor
        }
        view.layer.borderWidth = 4
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
    }


    static func getAvatarName(from name: String) -> String {
        let words = name.components(separatedBy: " ")

        var avatar = ""

        for (index, word) in words.enumerated() where index < 2 {
            if let character = word.first {
                avatar += "\(character)"
            }
        }

        if avatar.count == 1 {
            let trimmedName = "\(name.dropFirst())"
            if let nextCharacter = trimmedName.first {
                avatar += "\(nextCharacter)"
            }
        }

        return avatar.uppercased()
    }
    static func getDate()-> String{
        let date = Date()
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let dateStr = iso8601DateFormatter.string(from: date)
        return dateStr
    }
    
    static func getTimeStamp()-> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: currentDateTime)
    }
    
    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
    
    
    func segmenEvent(_ event: String, _ properties: [String:Any]){
        Analytics.shared().track(event, properties: properties)
    }

}

protocol ErrorProtocol: LocalizedError {
    var title: String { get }
    var code: Int? { get }
    var localizedDescription: String { get }

}

struct CustomError: ErrorProtocol {
    var title: String = "Error"
    var code: Int?
    var localizedDescription: String {
        title
    }
}

enum MeetingFlow: String {
    case join = "join", start = "start"
}

enum Layout {
    case grid, portrait
}

enum VideoCellState {
    case insert(index: Int)
    case delete(index: Int)
    case refresh(indexes: (Int, Int))
}

enum ChatType {
    case peer(String), group(String)
    
    var description: String {
        switch self {
        case .peer:  return "peer"
        case .group: return "channel"
        }
    }
    
}
struct Message {
    var userId: String
    var text: String
    var timestamp : String
}

//extension UIFont {
//    private static func registerFont(withName name: String, fileExtension: String) {
//        let frameworkBundle = Bundle(identifier: Constants.bundleId)
//        let pathForResourceString = frameworkBundle!.path(forResource: name, ofType: fileExtension)
//        let fontData = NSData(contentsOfFile: pathForResourceString!)
//        let dataProvider = CGDataProvider(data: fontData!)
//        let fontRef = CGFont(dataProvider!)
//        var errorRef: Unmanaged<CFError>? = nil
//
//        if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
//            print("Error registering font")
//        }
//    }
//
//    public static func loadFonts() {
//        registerFont(withName: "Montserrat-Bold", fileExtension: "ttf")
//        registerFont(withName: "Montserrat-SemiBold", fileExtension: "ttf")
//        registerFont(withName: "Montserrat-Regular", fileExtension: "ttf")
//
//        print("Registered suggessfully")
//    }
//}




extension UIViewController {
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 50, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        toastLabel.center = self.view.center
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

class DictionaryDecoder {

    private let decoder = JSONDecoder()

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        set { decoder.dateDecodingStrategy = newValue }
        get { return decoder.dateDecodingStrategy }
    }

    var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy {
        set { decoder.dataDecodingStrategy = newValue }
        get { return decoder.dataDecodingStrategy }
    }

    var nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy {
        set { decoder.nonConformingFloatDecodingStrategy = newValue }
        get { return decoder.nonConformingFloatDecodingStrategy }
    }

    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        set { decoder.keyDecodingStrategy = newValue }
        get { return decoder.keyDecodingStrategy }
    }

    func decode<T>(_ type: T.Type, from dictionary: [String: Any]) throws -> T where T : Decodable {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        return try decoder.decode(type, from: data)
    }
    
    
    
}
   
extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}
extension Array where Element: Equatable {
    func indexes(of element: Element) -> [Int] {
        return self.enumerated().filter({ element == $0.element }).map({ $0.offset })
    }
}
