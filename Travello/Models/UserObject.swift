//
//  UserObject.swift
//  Travello
//
//  Created by Md Munir Hossain on 7/30/18.
//  Copyright © 2018 Md Munir Hossain. All rights reserved.
//

import Foundation
class UserObject {
    private var _address: String?
    private var _age: String?
    private var _avata: String?
    private var _email: String?
    private var _id: String?
    private var _imageUrl: String?
    private var _name: String?
    private var _phoneNumber: String?
    private var _provider: String?

    
    var address: String?{
        get{
            return _address
        }
        set{
            _address = newValue
        }
    }
    var age: String?{
        get{
            return _age
        }
        set{
            _age = newValue
        }
    }
    var avata: String?{
        get{
            return _avata
        }
        set{
            _avata = newValue
        }
    }
    var email: String?{
        get{
            return _email
        }
        set{
            _email = newValue
        }
    }
    var id: String?{
        get{
            return _id
        }
        set{
            _id = newValue
        }
    }
    var imageUrl: String?{
        get{
            return _imageUrl
        }
        set{
            _imageUrl = newValue
        }
    }
    var name: String?{
        get{
            return _name
        }
        set{
            _name = newValue
        }
    }
    var phoneNumber: String?{
        get{
            return _phoneNumber
        }
        set{
            _phoneNumber = newValue
        }
    }
    
    var provider: String?{
        get{
            return _provider
        }
        set{
            _provider = newValue
        }
    }
    init(address: String,age: String,avata: String,email: String,id: String,imageUrl:String,name: String,phoneNumber: String,provider: String) {
        self._address = address
        self._age = age
        self._avata = avata
        self._email = email
        self._id = id
        self._imageUrl = imageUrl
        self._name = name
        self._phoneNumber = phoneNumber
        self._provider = provider
        }
    
    //this is for facebook user
    init(authId: String, dict: Dictionary<String, AnyObject>) {
        self._id = authId
        if let name = dict["name"] as? String{
            _name = name
        }
        if let email = dict["email"] as? String{
            _email = email
        }
        if let picture = dict["picture"] as? Dictionary<String,AnyObject>{
            if let data = picture["data"] as? Dictionary<String,AnyObject>{
                if let imageUrl = data["url"] as? String{
                    _imageUrl = imageUrl
                }
            }
        }
        self._address = ""
        self._age = ""
        self._avata = ""
        self._phoneNumber = ""
        self._provider = Constants.FB_PROVIDER
    }
    
}
