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
    
    func regiser_new_user(mail : String  ,pass : String , userName : String)
    {
        
        Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
            if error != nil{
                print("errorrr")
                return
            }
            print("100X")
            print("sign in succes")
            let userRef = self.ref.child("users")
            //print(self.ref.description()) : https://instagramfirebase-6b380.firebaseio.com/users
            //let uid = user?.Uid
            let userID = Auth.auth().currentUser!.uid
            let newUserRef = userRef.child(userID)
            newUserRef.setValue(["userName": userName , "email" : mail])
            print(newUserRef.description())
            
        }
    }
    
  
        
        
    
    func signInByEmailAndPass(email : String, pass : String){
        
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if(error != nil){
                print("error to sign in,try again")
                return
            }
            print("sign in succes")
            let userRef = self.ref.child("users")
            print(self.ref.description())
            
            
        }
       
        
    }
    
    
}
