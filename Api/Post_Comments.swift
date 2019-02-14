//
//  Post_Comments.swift
//  InstagramApplication
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
class Post_Comments{
    
    var REF_Post_Comments = Database.database().reference().child("post_comments")
    
//    func observePostComments(withPostId id : String, complition : @escaping (Post_Comments)-> Void){
//        REF_Post_Comments.observeSingleEvent(of: .value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String : Any]{
//                let newComment = Post_Comments.transformCommet(dictionary: dict)
//                complition(newComment)
//            }
//        })
//    }
    
    
    
}
