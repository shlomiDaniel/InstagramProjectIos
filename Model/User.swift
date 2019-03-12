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
    var id : String
    //let name : String
    //let phone : String
    //let url : String
    var userName : String?
    let Password : String
    var profile_image_url : String?
    var email : String?
    //var is_following : Bool?
    // userName : String?
    
    init ( _id : String , _userName : String, _password : String,_email : String ,profile_image_url : String){
        self.id = _id
        //self.name = _name
        //self.phone = _phone
        //self.url = _url
        self.userName = _userName
        self.Password = _password
        self.email = _email
        self.profile_image_url = profile_image_url
    }

    init ( _id : String , _userName : String, _password : String,_email : String){
        self.id = _id
        //self.name = _name
        //self.phone = _phone
        //self.url = _url
        self.userName = _userName
        self.Password = _password
        self.email = _email
//        self.profile_image_url = profile_image_url
    }

//    init ( _id : String , _name : String , _phone : String = "1234567" , _url : String = "" , _userName : String , _password : String
//        ){
//        self.id = _id
//        //self.name = _name
//        //self.phone = _phone
//        //self.url = _url
//        self.userName = _userName
//        self.Password = _password
//    }
    
    init(){
        self.id = ""
     
        self.userName = ""
        self.Password = ""
        self.email = ""
    }
    init ( jason : [String : Any]){
        self.id = jason["id"] as! String
        self.email = jason["email"] as! String
        self.Password = jason["pass"] as! String
        self.profile_image_url = jason["url_profile_image"] as! String
        self.userName =  jason["userName"] as! String
    
    }
    func toJson() -> [String : Any]{
        var jason = [String : Any]()
         jason["id"] = self.id
         jason["email"] = self.email
         jason["pass"] = self.Password
        jason["url_profile_image"] = self.profile_image_url
         jason["userName"]  = self.userName
        
        return jason
    }
    
}
extension User{
    
    static func transformUserInfo(dict : [String:Any],key: String)->User{
        let user = User()
        user.email = dict["email"] as? String
        user.profile_image_url = dict["url_profile_image"] as? String
        user.userName = dict["userName"] as? String
        user.id = key
        return user
        }
    
}
