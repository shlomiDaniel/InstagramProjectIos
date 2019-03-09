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
    var users = [User]()
    var comments = [Comment]()
    
    init(){
        FirebaseApp.configure()
        ref = Database.database().reference()
        
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
        ref.child("users").child(id).setValue(["email" : email , "pass" : pass , "userName" : userName,"user_name_lower_case" : userName.lowercased() , "url_profile_image" : url])
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
                   //self.sendDataToDataBase(photo_url: the_url)
                    self.sendImageProfie(photo_url: the_url)
                    return
                }
                if child == "posts"{
                    
                    self.sendDataToDataBase_posts_image_and_text(photo_url: the_url,text : text)
                    return
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
        //posts.removeAll()
             //posts.removeAll()
        let post_ref = ref.child("posts")
        let new_post_id  = post_ref.childByAutoId().key
        let new_post_ref = post_ref.child(new_post_id!)
        let uid = getUserId()
            new_post_ref.setValue(["uid": uid,"photo_url": photo_url,"text_share" : text,"likeCount" : 0]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
            //ref.child("feed").child(Api.User.current_user!.uid).child(new_post_id!).setValue(true)
            //Api.feed.ref_feed.child(Api.User.current_user!.uid).child(new_post_id!).setValue(true)
            let my_post_ref = Api.my_posts.REF_POSTS.child(self.getUserId()).child(new_post_id!)
            my_post_ref.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
            
            
        })
      }
    }
    /////
    func updatePhoto_profile(text: String) {
        let user_info = Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "")
        let values = ["url_profile_image": text]
        user_info.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            print("Successfully saved user to database.")
        })
    }
    
    func sendImageProfie(photo_url : String){
       
        updatePhoto_profile(text : photo_url)
        
    }
    
    
    func sendDataToDataBase(photo_url : String){
        //check it may casues crasheed!!!!
        posts.removeAll()
        let post_ref = ref.child("posts")
        let new_post_id  = post_ref.childByAutoId().key
        let new_post_ref = post_ref.child(new_post_id!)
   
        new_post_ref.setValue(["photo_url": photo_url]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }else{
                SVProgressHUD.showSuccess(withStatus: "shared succes")
            }
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

//        Api.feed.observeFeed(withid: Api.User.current_user!.uid) { (post) in
//                        guard let post_id = post.uid else {
//                            return
//                        }
//            self.fetchUser(uid : post_id, completed :{
//
//                            self.posts.append(post)
//                            table_view.reloadData()
//                        })
//
//            }
//        Api.feed.observe_feed_removed(withid: Model.instance.modelFirebase.getUserId()) { (post) in
//
//
//           self.posts = self.posts.filter{$0.id != post.id}
//           self.users = self.users.filter{$0.id != post.uid}
//
//            table_view.reloadData()
//        }
//        Api.post.observePosts { (post) in
//            self.fetchUser(uid: post.uid!, completed: {
//                self.posts.append(post)
//
//                table_view.reloadData()
//
//            })
        //posts.removeAll()
            Api.post.REF_POSTS.observe(.childAdded, with: { (snapshot) in
                if let dict = snapshot.value as? [String : Any]{
                    let newpost = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                    self.fetchUser(uid: newpost.uid!, completed: {
                        self.posts.append(newpost)
                    table_view.reloadData()
                        
                    })

                }
            })

       // }
//        Api.post.observePost(withId: post) { (post) in
//            <#code#>

        Model.instance.modelFirebase.posts.removeAll()
        Model.instance.modelFirebase.users.removeAll()
        table_view.reloadData()
        Api.feed.observeFeed(withid: Api.User.current_user!.uid) { (post) in
                        guard let post_id = post.uid else {
                            return
                        }
            self.fetchUser(uid : post.uid!, completed :{

                            self.posts.append(post)
                            table_view.reloadData()
                        })

            }
        Api.feed.observe_feed_removed(withid: Api.User.current_user!.uid) { (post) in


           self.posts = self.posts.filter{$0.id != post.id}
           self.users = self.users.filter{$0.id != post.uid}

            table_view.reloadData()
        }
//        Api.post.observePost(withId: Api.User.current_user!.uid) { (post) in
//            self.posts.append(post)
//            table_view.reloadData()
//        }
//        Api.post.observePosts { (post) in
//            self.posts.append(post)
//            table_view.reloadData()

//        }
    }
    func fetchUser(uid : String, completed : @escaping()->Void){
        
        UserApi().observeUser(withId: uid, complition: {
            user in
            self.users.append(user)
            completed()
        })
        

        
        
    }
    
    func fetchUser(uid : String){
     
        
        
    }
}

