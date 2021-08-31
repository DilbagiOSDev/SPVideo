//
//  InputData.swift
//  SampleFramework
//
//  Created by Gowthaman G on 03/07/21.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import Segment




class InputData: NSObject {
    
    static let sharedInstance = InputData()
    private override init() {
        super.init()
        let bundle = Bundle(url: Bundle(for: SetupViewController.self).url(forResource: "SPVideo", withExtension: "bundle")!)!
        
        //let pathForResourceString = bundle.path(forResource: name, ofType: fileExtension)
        //let bundle = Bundle(identifier: Constants.bundleId)
        print("bundle\(String(describing: bundle))")
        let path = bundle.path(forResource: "GoogleService-Info", ofType: "plist")
        print("path\(String(describing: path))")
        //        let filePath = bundle!.path(forResource: "GoogleService-Info", ofType: "plist")
        //let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        
        
        if let lPath = path {
            let options = FirebaseOptions(contentsOfFile: lPath)
            FirebaseApp.configure(options: options!)
            Firestore.firestore()
        }else {
            print("No Google plist file path is found")
        }
        
    }
    
    func setData(username: String, meetingId: String, token: String? = nil) {
        UserDefaults.standard.setValue(username, forKey: Constants.defaultName)
        UserDefaults.standard.setValue(meetingId, forKey: Constants().meetingId)
        UserDefaults.standard.setValue(token ?? "token", forKey: Constants().token)
        UserDefaults.standard.setValue("front", forKey: Constants.cameraPos)
        UserDefaults.standard.setValue("Host", forKey: Constants.role)
        
        
        UIFont.loadFonts()
        let configuration = AnalyticsConfiguration(writeKey: Constants().segmentKey)
        configuration.trackApplicationLifecycleEvents = true // Enable this to record certain application events automatically!
        configuration.recordScreenViews = true // Enable this to record screen views automatically!
        Analytics.setup(with: configuration)
        
        
        let flow: MeetingFlow = .join
        UserDefaults.standard.setValue(flow.rawValue, forKey: Constants.flow)
        if let navigationController = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController as? UINavigationController {
            print("Nav has vale \(navigationController)")
            navigationController.setNavigationBarHidden(true, animated: true)
            let bundle = Bundle(identifier: Constants.bundleId)
            let storyBoard: UIStoryboard = UIStoryboard(name: Constants.landscene, bundle: bundle)
            let balanceViewController = storyBoard.instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
            navigationController.pushViewController(balanceViewController, animated: true)
        }
    }
}

