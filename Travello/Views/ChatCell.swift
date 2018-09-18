//
//  ChatCell.swift
//  Travello
//
//  Created by Md Munir Hossain on 9/17/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var name_lbl: UILabel!
    @IBOutlet weak var message_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var profile_image: CircleImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sizeToFit()
        layoutIfNeeded()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(sender: UserObject,reciever: UserObject, chat: MessageObject){
        
        name_lbl.text = chat.text
        message_lbl.text = chat.text
        time_lbl.text = "\(chat.timestamp)"
        if let cached_user_image = profile_imageCache.object(forKey: sender.imageUrl! as NSString){
            print("image from cache")
            profile_image.image = cached_user_image
        }else{
            if let imageUrl = sender.imageUrl{
                profile_image.imageFromServerURL(urlString: sender.imageUrl!, defaultImage: "No Image")
                if let image = profile_image.image{
                    profile_imageCache.setObject(image, forKey: imageUrl as NSString)
                }
            }
        }
        profile_image.clipsToBounds = true
        
    }
}
