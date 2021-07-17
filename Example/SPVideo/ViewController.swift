//
//  ViewController.swift
//  SPVideo
//
//  Created by aravindhu-gloify on 07/15/2021.
//  Copyright (c) 2021 aravindhu-gloify. All rights reserved.
//

import UIKit
import SPVideo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExternalInputData.init().setData(username: "YOUR_NAME", meetingId: "YOUR_MEETING_ID", token: "YOUR_TOKEN")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

