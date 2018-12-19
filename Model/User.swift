//
//  User.swift
//  InstagramApplication
//
//  Created by admin on 19/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation
class User{
    //members
    let id : String
    let name : String
    let phone : String
    let url : String
    let userName : String
    let Password : String
    init ( _id : String , _name : String , _phone : String , _url : String , _userName : String , _password : String){
        self.id = _id
        self.name = _name
        self.phone = _phone
        self.url = _url
        self.userName = _userName
        self.Password = _password
        
    }
    //from jason
    init ( jason : [String : Any]){
        self.id = jason["id"] as! String
        self.name = jason["name"] as! String
        self.phone = jason["phone"] as! String
        self.url = jason["url"] as! String
        self.userName =  jason["userName"] as! String
        self.Password = jason["password"] as! String
        
    }
    //to jason
    
    func toJson() -> [String : Any]{
        var jason = [String : Any]()
         jason["id"] = self.id
         jason["name"] = self.name
         jason["phone"] = self.phone
         jason["url"] = self.url
         jason["userName"]  = self.userName
         jason["password"] = self.Password
        return jason
    }
    
    
    
    
    
    
}
