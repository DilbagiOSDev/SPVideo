//
//  ChatMessageTableViewCell.swift
//  SampleFramework
//
//  Created by Gowthaman G on 04/07/21.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var uilabel_avatar: UILabel!{
        didSet {
            uilabel_avatar.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var uilabel_name: UILabel!
    @IBOutlet weak var uilabel_timestamp: UILabel!
    @IBOutlet weak var uilabel_message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
