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
    
    var text_share : String?
    var image_url : String?
    var uid : String?
    //var videoUrl : String?
    
    init(){
        self.image_url = nil
        self.text_share = nil
        //self.videoUrl = nil
    }
    

        
    
}
    

extension Post{
     static func transformPostPhoto(dictionary : [String : Any]) -> Post {
        let post = Post()
        post.image_url = dictionary["photo_url"] as? String
        post.text_share = dictionary["text_share"] as? String
        post.uid = dictionary["uid"] as? String
        return post
        
    }
     func transformPostVideo(){
       
        
    }
    
}
