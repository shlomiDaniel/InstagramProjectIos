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
    var userName : String?
    let Password : String
    var profile_image_url : String?
    var email : String?
    // userName : String?
    
    init ( _id : String , _name : String , _phone : String = "1234567" , _url : String = "" , _userName : String , _password : String,_email : String ,profile_image_url : String
        ){
        self.id = _id
        self.name = _name
        self.phone = _phone
        self.url = _url
        self.userName = _userName
        self.Password = _password
        self.email = _email
        self.profile_image_url = profile_image_url

    }
    init ( _id : String , _name : String , _phone : String = "1234567" , _url : String = "" , _userName : String , _password : String
        ){
        self.id = _id
        self.name = _name
        self.phone = _phone
        self.url = _url
        self.userName = _userName
        self.Password = _password
        
        
    }
    init(){
        self.id = ""
        self.name = ""
        self.phone = ""
        self.url = ""
        self.userName = ""
        self.Password = ""
        self.email = ""
        //self.profile_image_url = ""
    }
    //from jason
    init ( jason : [String : Any]){
        self.id = jason["id"] as! String
        self.name = jason["name"] as! String
        self.phone = jason["phone"] as! String
        self.url = jason["url"] as! String
        self.userName =  jason["userName"] as! String
        self.Password = jason["password"] as! String
        self.email = jason["email"] as! String
        self.profile_image_url = jason["profile_image_url"] as! String
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
extension User{
    
    static func transformUserInfo(dict : [String:Any])->User{
        let user = User()
        user.email = dict["email"] as! String
        user.profile_image_url = dict["profile_image_url"] as? String
        user.userName = dict["userName"] as! String
        return user
        }
    
}
