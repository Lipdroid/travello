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
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    var REF_USER: FIRDatabaseReference{
        return _REF_USER
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
                
                let mUserObj = UserObject(address: address,age: age,avata: avata,email: email,id: uid,imageUrl: imageUrl,name: name,phoneNumber: phoneNumber)
                callback(mUserObj)
            }else{
                print("firebase error")
            }
        })
    }
}
