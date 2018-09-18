//
//  SavedCell.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/14/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Cosmos
class SavedCell: UITableViewCell {
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fare: UILabel!
    @IBOutlet weak var seats: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pro_image: CircleImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var btn_chat: UIImageView!

    var carcellDelegate: CarcellDelegate?
    var carObject: CarObject?

    func updateViews(carObj: CarObject){
        carObject = carObj
        fromAddress.text = carObj.origin
        toAddress.text = carObj.destination
        date.text = carObj.dates
        fare.text = carObj.gas_fare
        seats.text = carObj.available_seats
        name.text = carObj.name
        email.text = carObj.email
        //show image from image url
        if let imageUrl = carObj.image{
            if(imageUrl == "" || !imageUrl.hasPrefix("https")){
                pro_image.image = UIImage(named: "default_avata")
            }else{
                pro_image.imageFromServerURL(urlString: imageUrl, defaultImage: "default_avata")
            }
        }
        
        if carObj.is_plan_a_trip{
            background.backgroundColor = UIColor(hexColor: "DD6B55")
        }else{
            background.backgroundColor = UIColor(hexColor: "0097A7")
        }
        // Change the cosmos view rating
        if let rate:Int = Int(carObj.rating){
            rating.rating = Double(rate)
        }
        
        phone.text = carObj.phone_no
        let btn_chat_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didChatTapped(tapGestureRecognizer:)))
        btn_chat.isUserInteractionEnabled = true
        btn_chat.addGestureRecognizer(btn_chat_tapGestureRecognizer)

    }
    
    @objc func didChatTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        carcellDelegate?.didChatTapped(id: (carObject?.id)!)
    }
}


