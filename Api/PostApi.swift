//
//  PostApi.swift
//  InstagramApplication
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
class PostApi{
    var REF_POSTS = Database.database().reference().child("posts")
    
    func observePosts(complition : @escaping (Post)->Void){
        REF_POSTS.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let new_post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                complition(new_post)
            }
        }
    }
    
    func observe_top_posts(complition : @escaping (Post)->Void){
        REF_POSTS.queryOrdered(byChild: "likeCount").observeSingleEvent(of: .value) { (snapshot) in
            let array_snapshot = (snapshot.children.allObjects as! [DataSnapshot]).reversed()
            array_snapshot.forEach({ (child) in
                if let dict = child.value as? [String : Any]{
                    let new_post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                    complition(new_post)
                }
            })
            
        }
    }
    
    func observePost(withId uid: String,complition : @escaping (Post)->Void){
        REF_POSTS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                let post = Post.transformPostPhoto(dictionary: dict,key: snapshot.key)
                complition(post)
            }
        }
    }
    
}
