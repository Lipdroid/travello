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
    @IBOutlet weak var btn_add: UIButton!
    
    var userObject: UserObject!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(userData: UserObject){
        self.userObject = userData
        time.isHidden = true
        name.text = userData.name
        message_txt.text = userData.email
        //show image from image url
        if let imageUrl = userData.imageUrl{
            if(imageUrl == "" || !imageUrl.hasPrefix("https")){
                pro_image.image = UIImage(named: "default_avata")
            }else{
                pro_image.imageFromServerURL(urlString: imageUrl, defaultImage: "default_avata")
            }
        }
        
    }
}
