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
}
