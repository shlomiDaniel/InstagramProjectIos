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
    //REF_USER.child("").
    // func observeUser
    
    func observeUser(withId uid: String,complition : @escaping (User)->Void){
        REF_USER.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = User.transformUserInfo(dict: dict)
                complition(user)
            }
        }
    }
    
    func observe_currect_user(complition : @escaping(User)->Void){
        guard let uid = Auth.auth().currentUser else {
            //return nil
            return
            
        }
        REF_USER.child(uid.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let user = User.transformUserInfo(dict: dict)
                complition(user)
            }
        
    }
    
    var REF_CURRENT_USER : DatabaseReference? {
        guard let uid = Auth.auth().currentUser else {
            //return nil
            return nil
        }
        return REF_USER.child(uid.uid)
    }
}
}
