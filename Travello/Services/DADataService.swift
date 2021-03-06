//
//  DADataService.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/30/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()
class DADataService{
    static let instance = DADataService()
    private let _REF_BASE = DB_BASE
    private let _REF_USER = DB_BASE.child("user")
    private let _REF_CAR = DB_BASE.child("car")
    private let _REF_SAVE = DB_BASE.child("save")
    private let _REF_FRIEND = DB_BASE.child("friend")
    private let _REF_MESSAGE = DB_BASE.child("message")

    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    var REF_USER: FIRDatabaseReference{
        return _REF_USER
    }
    var REF_CAR: FIRDatabaseReference{
        return _REF_CAR
    }
    var REF_SAVE: FIRDatabaseReference{
        return _REF_SAVE
    }
    var REF_FRIEND: FIRDatabaseReference{
        return _REF_FRIEND
    }
    
    var REF_MESSAGE: FIRDatabaseReference{
        return _REF_MESSAGE
    }
    
    func getUserFromFirebaseDB(uid: String,callback: @escaping Completion){
        REF_USER.child(uid).observeSingleEvent(of: .value, with: {(snapshot) in
            if let snap = snapshot.value as? Dictionary<String,String>{
                guard let address = snap["address"] else{ return}
                guard let age = snap["age"] else{ return}
                guard let avata = snap["avata"] else{ return}
                guard let email = snap["email"] else{ return}
                guard let imageUrl = snap ["imageUrl"] else{ return}
                guard let name = snap ["name"] else{ return}
                guard let phoneNumber = snap ["phoneNumber"] else{ return}
                //old android version doesnot have provider so check
                //provider available or not
                //if not available just set an empty string
                if let provider = snap ["provider"]{
                    let mUserObj = UserObject(address: address,age: age,avata: avata,email: email,id: uid,imageUrl: imageUrl,name: name,phoneNumber: phoneNumber,provider: provider)
                    callback(mUserObj)
                } else{
                    let mUserObj = UserObject(address: address,age: age,avata: avata,email: email,id: uid,imageUrl: imageUrl,name: name,phoneNumber: phoneNumber,provider: "")
                    callback(mUserObj)
                }
            
            }else{
                print(snapshot)
            }
        })
    }
    
    func createFirebaseDBUser(uid: String, userObject: UserObject){
        let user = ["address": userObject.address,
                    "age": userObject.age,
                    "avata": userObject.avata,
                    "email": userObject.email,
                    "id":uid,
                    "imageUrl":userObject.imageUrl,
                    "name":userObject.name,
                    "phoneNumber":userObject.phoneNumber,
                    "provider":userObject.provider]
        
        REF_USER.child(uid).updateChildValues(user as Any as! [AnyHashable : Any])
    }
    
    func createMessage(roomID: String, messageObj: MessageObject){
        let message = ["idSender": messageObj.idSender,
                       "idReceiver": messageObj.idReceiver,
                       "timestamp": messageObj.timestamp,
                       "text": messageObj.text] as [String : Any]
        
        REF_MESSAGE.child(roomID).childByAutoId().setValue(message as Any as! [AnyHashable : Any])
    }
    
    func createFirebaseDBCar(uid: String, carObject: CarObject){
        let car = ["avaiable_seats": carObject.available_seats,
                    "dates": carObject.dates,
                    "description": carObject.description,
                    "destination": carObject.destination,
                    "email":carObject.email,
                    "gas_fare":carObject.gas_fare,
                    "id":carObject.id,
                    "image":carObject.image,
                    "is_plan_a_trip":carObject.is_plan_a_trip,
                    "liked": carObject.liked,
                    "name": carObject.name,
                    "origin":carObject.origin,
                    "phone_no":carObject.phone_no,
                    "rating":carObject.rating,
                    "user_id":carObject.user_id,
                    "usertype":carObject.usertype] as [String : Any]
        
        REF_CAR.child(uid).updateChildValues(car as Any as! [AnyHashable : Any])
    }
    
    func createFirebaseDBSave(uid: String, carObject: CarObject){
        let car = ["avaiable_seats": carObject.available_seats,
                   "dates": carObject.dates,
                   "description": carObject.description,
                   "destination": carObject.destination,
                   "email":carObject.email,
                   "gas_fare":carObject.gas_fare,
                   "id":carObject.id,
                   "image":carObject.image,
                   "is_plan_a_trip":carObject.is_plan_a_trip,
                   "liked": carObject.liked,
                   "name": carObject.name,
                   "origin":carObject.origin,
                   "phone_no":carObject.phone_no,
                   "rating":carObject.rating,
                   "user_id":carObject.user_id,
                   "usertype":carObject.usertype] as [String : Any]
        
        REF_SAVE.child(uid).updateChildValues(car as Any as! [AnyHashable : Any])
    }
    
    func updateFirebaseDBCarLike(uid: String, carObject: CarObject){
        let liked = ["liked": carObject.liked] as [String : Any]
        REF_CAR.child(uid).updateChildValues(liked as Any as! [AnyHashable : Any])
    }
    
    func addToFriendList(currentUserID: String,addedUserID: String){
        REF_FRIEND.child(currentUserID).childByAutoId().setValue(addedUserID)
        REF_FRIEND.child(addedUserID).childByAutoId().setValue(currentUserID)
    }
}
