//
//  CarCell.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/10/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import UIKit
import Cosmos
protocol CarcellDelegate {
    func didLikeTapped(carObj: CarObject);
    func didCallTapped(phoneNo: String);
}
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
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var btn_like: UIImageView!
    var carObject: CarObject?
    var carcellDelegate: CarcellDelegate?
    
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
        
        if(carObj.liked == 1){
            btn_like.image = UIImage(named:"liked")
        }else{
            btn_like.image = UIImage(named:"like")
        }
        
        let btn_like_tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didLikeTapped(tapGestureRecognizer:)))
        btn_like.isUserInteractionEnabled = true
        btn_like.addGestureRecognizer(btn_like_tapGestureRecognizer)
        

    }
    
    @objc func didLikeTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        carcellDelegate?.didLikeTapped(carObj: carObject!)
    }
    
    @IBAction func didCallTapped(_ sender: Any) {
        if let phone = carObject?.phone_no {
            if phone != ""{
                carcellDelegate?.didCallTapped(phoneNo: phone)
            }
        }
    }
}

