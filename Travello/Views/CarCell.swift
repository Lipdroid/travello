//
//  CarCell.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/10/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit

class CarCell: UITableViewCell {
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var fare: UILabel!
    @IBOutlet weak var seats: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var pro_image: CircleImageView!
    @IBOutlet weak var background: UIView!
    
    func updateViews(carObj: CarObject){
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
    }
}

