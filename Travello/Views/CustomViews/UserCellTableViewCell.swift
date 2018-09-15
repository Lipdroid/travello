//
//  UserCellTableViewCell.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/14/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit

class UserChatCell: UITableViewCell {
    @IBOutlet weak var pro_image: CircleImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message_txt: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func updateCell(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
