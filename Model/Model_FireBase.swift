//
//  Model_FireBase.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class ModelFireBase{
    
    var ref : DatabaseReference!
    init(){
        FirebaseApp.configure()
        ref = Database.database().reference()
        
        
    }
    
    func regiser_new_user(mail : String  ,pass : String)
    {
        
        Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
            if error != nil{
                print("errorrr")
                return
            }
            print("100X")
        }
    }
    
  
        
        
    
    func signInByEmailAndPass(email : String, pass : String){
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if(error != nil){
                print("error to sign in,try again")
                return
            }
            print("sign in succes")
        }
       
        
    }
    
    
}
