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
import FirebaseAuth

class Post{
    
    var text_share : String?
    var image_url : String?
    var uid : String?
    var id : String?
    var numberOfLikes : Int?
    var likes : Dictionary<String,Any>?
    var isLike : Bool?
    
    init(){
        self.image_url = nil
        self.text_share = nil
        self.numberOfLikes = 0
        //self.videoUrl = nil
    }
    
    init (_id: String,  _likeCount: Int, _image_url: String, _text_share: String) {
        self.id = _id;
        self.numberOfLikes = _likeCount;
        self.image_url = _image_url;
        self.text_share = _text_share;
    }
    

        
    
}
    

extension Post{
    static func transformPostPhoto(dictionary : [String : Any], key : String) -> Post {
        let post = Post()
        post.id = key
        post.image_url = dictionary["photo_url"] as? String
        post.text_share = dictionary["text_share"] as? String
        post.uid = dictionary["uid"] as? String
        post.numberOfLikes = dictionary["likeCount"] as? Int
        post.likes = dictionary["likes"] as? Dictionary<String,Any>
        var uid = Auth.auth().currentUser?.uid
        if let currentUserId = Auth.auth().currentUser?.uid{
            if(post.likes != nil){
                post.isLike = post.likes![currentUserId] != nil

                
            }
        }
       
        return post
        
    }
     func transformPostVideo(){
       
        
    }
    
}
