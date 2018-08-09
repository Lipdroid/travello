//
//  CarObject.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/9/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
class CarObject{
    public var available_seats: String!
    public var dates: String!
    public var description: String!
    public var destination: String!
    public var email: String!
    public var gas_fare: String!
    public var id: String!
    public var image: String!
    public var is_plan_a_trip: String!
    public var liked: String!
    public var name: String!
    public var origin: String!
    public var phone_no: String!
    public var rating: String!
    public var user_id: String!
    public var usertype: String!
    
    init(available_seats: String,dates: String,description: String,destination: String,email: String,gas_fare: String,
         id: String,image: String,is_plan_a_trip: String,liked: String,
         name: String,origin: String,phone_no: String,rating: String,
         user_id: String,usertype: String) {
        
        self.available_seats = available_seats
        self.dates = dates
        self.description = description
        self.destination = destination
        self.email = email
        self.gas_fare = gas_fare
        self.id = id
        self.image = image
        self.is_plan_a_trip = is_plan_a_trip
        self.liked = liked
        self.name = name
        self.origin = origin
        self.phone_no = phone_no
        self.rating = rating
        self.user_id = user_id
        self.usertype = usertype
    }
}
