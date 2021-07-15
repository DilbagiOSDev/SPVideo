//
//  SetupViewModel.swift
//  VideoFramework
//
//  Created by Gowthaman G on 05/07/21.
//

import Foundation
import UIKit

typealias SelectedCell = (_ indexPath:IndexPath,_ tableView:UITableView) -> Void


class SetupViewModel : NSObject{
    var selected_cell:SelectedCell?
    private weak var tableview_options: UITableView?
    fileprivate(set) var options: [String] = []
    var selectedOption : String!
    
    // MARK: - Initializers

    init(_ options: [String], _ tableView: UITableView) {

        super.init()
        
        self.options = options

        setup(tableView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setup(_ tableView: UITableView) {
        self.tableview_options = tableView
        //self.tableview_options?.reloadData()
    }
    
    func getMeetingPrivacy(){
        RoomService.getRoomPrivacy(UserDefaults.standard.value(forKey: Constants().meetingId) as! String, completion: {privacyStatus,error,_  in

            if let status = privacyStatus{
                print(#function,"privacy status is \(status)")
                
                NotificationCenter.default.post(name: Notification.Name("MeetPrivacy"), object: nil, userInfo: ["Status":status])
                
            }
            if let error = error{
                print(#function,"privacy status error is \(error)")
            }
        })
    }
    
    
}
