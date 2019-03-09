//
//  UserApi.swift
//  InstagramApplication
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserApi{
    
    var REF_USER = Database.database().reference().child("users")
    var current_user = Auth.auth().currentUser
    //REF_USER.child("").
    // func observeUser
   // var chrrent_user = Auth.auth().currentUser?.uid
    
    func observeUser(withId uid: String,complition : @escaping (User)->Void){
        REF_USER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = User.transformUserInfo(dict: dict,key : snapshot.key)
//                if user.id != Api.User.current_user!.uid{
//                    complition(user)
//
//                }
                complition(user)
            }
        }
    }
    
    func observeUser_with_child_added_event(complition : @escaping (User)->Void){
        REF_USER.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = User.transformUserInfo(dict: dict,key : snapshot.key)
                    complition(user)

            }
        }
        
    }
    
    var REF_CURRENT_USER : DatabaseReference? {
        guard let uid = Auth.auth().currentUser else {
            //return nil
            return nil
        }
        return REF_USER.child(uid.uid)
    }
    
    func observe_currect_user(complition : @escaping(User)->Void){
        guard let uid = Auth.auth().currentUser else {
            //return nil
            return
            
        }
        REF_USER.child(uid.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = User.transformUserInfo(dict: dict,key: snapshot.key)
                complition(user)
            }
        
    }
    
   
}
    
    func query_users(withtext text : String ,complition : @escaping(User)->Void){
        REF_USER.queryOrdered(byChild: "user_name_lower_case").queryStarting(atValue: text).queryEnding(atValue: text+"\u{f8ff}").observeSingleEvent(of: .value) { (snapshot) in
            snapshot.children.forEach({ (s) in
                let child = s as! DataSnapshot
                if let dict = child.value as? [String : Any]{
                    let user = User.transformUserInfo(dict: dict,key: snapshot.key)
                    complition(user)
                }
            })
        }
    }
    
}
