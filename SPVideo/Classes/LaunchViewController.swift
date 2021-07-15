//
//  LaunchViewController.swift
//  SampleFramework
//
//  Created by Gowthaman G on 03/07/21.
//

import Foundation
import UIKit

public class LaunchViewController: UIViewController {

    internal var meetname : String!
    internal var username : String!
    internal var flow : MeetingFlow!
    
    @IBOutlet weak var label_teamname: UILabel!{
        didSet {
            label_teamname.text = "SuperPro"
        }
    }
    
    
   public override func viewDidLoad() {
        super.viewDidLoad()
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            let bundle = Bundle(identifier: Constants.bundleId)
            let viewController = UIStoryboard(name: Constants.setup, bundle: bundle).instantiateInitialViewController() as? SetupViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
            
            
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar(animated: animated)
    }
    
//    xcodebuild -create-xcframework \
//        -framework './build/VideoFramework.framework-iphoneos.xcarchive/Products/Library/Frameworks/VideoFramework.framework' \
//        -output './build/VideoFramework.xcframework'

}

extension UIViewController {
    
    
    func hideNavigationBar(animated: Bool){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    @objc func doneButtonAction(){
        self.view.endEditing(true)
    }
 
}


