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
         //FirebaseApp.configure()
        
    }
    
    func regiser_new_user(mail : String  ,pass : String , userName : String )
    {
        
        Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
            if error != nil{
               print("error in create user")
            }else{
                print("create user succes")
            }
        }
        
        
    }
    
  
    func getAllUsers(callback:@escaping ([User])->Void){
        ref.child("users").observe(.value, with:
            {
            (snapshot) in
                var data = [User]()
                let value = snapshot.value as! [String : Any]
                for(_ , json) in value {
                    data.append(User(jason: json as! [String : Any]))
                }
            callback(data)
            })
        
    }
    
    
    func addNewUser(user : User){
        
        ref.child("users").child(user.id).setValue(user.toJson())
        
    }
    func getUser(byId : String)->User?{
        return nil
    }
    
    
    lazy var storageRef = Storage.storage().reference(forURL: "gs://instagramfirebase-6b380.appspot.com")
    
    func saveImage(image : UIImage , name : (String),callback : @escaping(String?)->Void)->String{
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(name)
        
        let metaData = StorageMetadata()
      metaData.contentType = "image/jpeg"
        var the_url = ""
        imageRef.putData(data!, metadata: metaData) { (metadata, error) in
            imageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    
                    print("errrorrrr image download url")
                    return
                }
                print("url:\(downloadURL)")
                callback(downloadURL.absoluteString)
                 the_url = downloadURL.absoluteString
                
            })
            
        }
        
        return the_url
    }
    
    func getImage(url : String , callback :@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if error != nil{
                callback(nil)
            }else{
                let image = UIImage(data : data!)
                callback(image)
            }
        }
        
        
        
    }
        
    
    func signInByEmailAndPass(email : String, pass : String){

        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if(error != nil){
                print("error to sign in,try again")
                return
            }
            print("sign in succes")
            //let userRef = self.ref.child("users")
            //print(self.ref.description())


        }


    }
    func checkIfSignIn()->Bool{
        
        return (Auth.auth().currentUser != nil)
    }
    
    
}

