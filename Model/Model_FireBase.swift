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
import SVProgressHUD

class ModelFireBase{
    
    var ref : DatabaseReference!
    var flag = false
    var posts = [Post]()
    init(){
        FirebaseApp.configure()
        ref = Database.database().reference()
        // posts =  [Post]()
        //flag : Bool = false
        //FirebaseApp.configure()
        
    }
    
    func regiser_new_user(mail : String  ,pass : String, callback : @escaping (Bool?)->Void)
    {
        Auth.auth().createUser(withEmail: mail, password: pass) { (user, error) in
            if error != nil{
                callback(false)
            }else{
                callback(true)
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
    
    func getUserInfo(userId:String, callback:@escaping ([User])->Void){
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
        print("")
    }
    func add_new_user(email : String , pass : String , userName : String , url : String){
        var id = getUserId()
        ref.child("users").child(id).setValue(["email" : email , "pass" : pass , "userName" : userName , "url_profile_image" : url])
    }
    
    func getUserId()->String{
        return Auth.auth().currentUser!.uid
    }
    
    func getUserName()->String?{
        return Auth.auth().currentUser?.email
    }
    
    func getUser(byId : String)->Void{
        getUserInfo(userId: byId, callback: { (data) in
            print(data)
        })
    }
    
    
    lazy var storageRef = Storage.storage().reference(forURL: "gs://instagramfirebase-6b380.appspot.com")
    
    func saveImage(image : UIImage , name : (String),child : String,text : String,callback : @escaping(String?)->Void)->String{
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child(child).child(name)
        //let image_storage_posts = storageRef.child(child).child(name)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        var the_url = ""
        imageRef.putData(data!, metadata: metaData) { (metadata, error) in
            imageRef.downloadURL(completion: { (url, error) in
                guard let downloadURL = url else {
                    
                    print("errrorrrr image download url")
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    return
                }
                print("url:\(downloadURL)")
                callback(downloadURL.absoluteString)
                the_url = downloadURL.absoluteString
                if child == "profile_image"{
                   self.sendDataToDataBase(photo_url: the_url)
                }
                if child == "posts"{
                    
                    self.sendDataToDataBase_posts_image_and_text(photo_url: the_url,text : text)
                }
                
                
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
    
    func childs(childs_aar : [String] , indx : Int){
        
    }
    
    func sendDataToDataBase_posts_image_and_text(photo_url : String, text : String) {
        let post_ref = ref.child("posts")
        let new_post_id  = post_ref.childByAutoId().key
        let new_post_ref = post_ref.child(new_post_id!)
        // let post
        new_post_ref.setValue(["photo_url": photo_url,"text_share" : text]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
            // ref.child("posts").child(id).setValue(["email" : email , "pass" : pass , "userName" : userName , "url_profile_image" : url])
        }
        
        
        
    }
    
    
    func sendDataToDataBase(photo_url : String){
        let post_ref = ref.child("posts")
        let new_post_id  = post_ref.childByAutoId().key
        let new_post_ref = post_ref.child(new_post_id!)
       // let post
        new_post_ref.setValue(["photo_url": photo_url]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
      // ref.child("posts").child(id).setValue(["email" : email , "pass" : pass , "userName" : userName , "url_profile_image" : url])
    }
    }
    
    func signInByEmailAndPass(email : String, pass : String, callback : @escaping (Bool?)->Void){
        Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
            if(error != nil){
                callback(false)
            }
            callback(true)
        }
    }
    
    func checkIfSignIn()->Bool{
        return (Auth.auth().currentUser != nil)
    }
    
    func sign_Out() -> Bool{
        do{
            try Auth.auth().signOut()
            return true
        }catch let error{
            return false
        }
    }
    
    func loadPost(table_view: UITableView) {
       
        ref.child("posts").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any]{
                var post = Post.transformPostPhoto(dictionary: dictionary)
                //let post = Post.transformPostPhoto(dictionary: dictionary)
            //post.transformPost(dictionary: dictionary)
                
                    self.posts.append(post)
                    table_view.reloadData()
                
            }
        }
    }
}

