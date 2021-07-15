//
//  SetupOptionsTableViewCell.swift
//  VideoFramework
//
//  Created by Gowthaman G on 05/07/21.
//

import UIKit

public class SetupOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var label_option: UILabel!
        
        @IBOutlet weak var uiview_selected: UIView!{
            didSet {
                Utilities.drawCornerView(on: uiview_selected as UIView)
            }
        }
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            uiview_selected.isHidden = false
        }else{
            uiview_selected.isHidden = true
        }
        
        // Configure the view for the selected state
    }
    
}
