//
//  Post.swift
//  InstagramApplication
//
//  Created by SHLOMI on 10 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class Post{
    
    let my_image : UIImage
    var image_url : String?
    let uid = Auth.auth().currentUser?.uid
    
    init(my_image : UIImage,url : String){
        self.my_image = my_image
        self.image_url = url
        
       
    }
    
    func uploadImage(){
//        let new_post_ref = Database.database().reference().child("profile_images").childByAutoId()
//        let new_post_key = new_post_ref.key
//        let image_data = self.my_image.jpegData(compressionQuality: 0.3)
//        let image_storage_ref = Storage.storage().reference().child("images")
//        let new_image_ref = image_storage_ref.child(new_post_ref.key ?? "key")
//        new_image_ref.putData(image_data!).observe(.success) { (snapshot) in
//         snapshot.reference.downloadURL(completion: { (url, error) in
//            snapshot.metadata?.storageReference?.downloadURL(completion: { (url, error) in
//                self.image_url = url?.absoluteString
//            })
//            })
//        }
//         //var data = data
//        image_storage_ref.getMetadata { (metadata, error) in
//            metadata?.storageReference?.downloadURL(completion: { (url, error) in
//                self.image_url = url?.absoluteString
//            })
   
        }

        
    
    
    
}
