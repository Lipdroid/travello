//
//  CarObject.swift
//  Travello
//
//  Created by Md Munir Hossain on 8/9/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
class CarObject{
    private(set) public var available_seats: String!
    private(set) public var dates: String!
    private(set) public var description: String!
    private(set) public var destination: String!
    private(set) public var email: String!
    private(set) public var gas_fare: String!
    private(set) public var id: String!
    private(set) public var image: String!
    private(set) public var is_plan_a_trip: String!
    private(set) public var liked: String!
    private(set) public var name: String!
    private(set) public var origin: String!
    private(set) public var phone_no: String!
    private(set) public var rating: String!
    private(set) public var user_id: String!
    private(set) public var usertype: String!
    
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
