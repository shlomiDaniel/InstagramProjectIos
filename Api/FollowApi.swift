//
//  FollowApi.swift
//  InstagramApplication
//
//  Created by SHLOMI on 16 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import Foundation
class FollowApi{
    var ref_followers = Model.instance.modelFirebase.ref.child("followers")
    var ref_following = Model.instance.modelFirebase.ref.child("following")
    
    
    func follow_action(with_user id : String){
        Api.my_posts.REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                for key in dict.keys{
                    Model.instance.modelFirebase.ref.child("feed").child(Api.User.current_user!.uid).child(key).setValue(true)
                    
                    
                }
            }
        }
       ref_followers.child(id).child(Model.instance.modelFirebase.getUserId()).setValue(true)
        
        ref_following.child(Model.instance.modelFirebase.getUserId()).child(id).setValue(true)
    }
    func unfollow_action(with_user id : String){
        
        Api.my_posts.REF_POSTS.child(id).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String : Any]{
                for key in dict.keys{
                    Model.instance.modelFirebase.ref.child("feed").child(Api.User.current_user!.uid).child(key).removeValue()
                    
                    
                }
            }
        }
        ref_following.child(id).child(Model.instance.modelFirebase.getUserId()).setValue(NSNull())
        
        ref_followers.child(Model.instance.modelFirebase.getUserId()).child(id).setValue(NSNull())
    }
    
    func is_following(user_id : String,completed : @escaping(Bool)-> Void){
        ref_followers.child(user_id).child(Api.User.current_user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                completed(false)
            }else{
                completed(true)
            }
            
            
        }
    }
}
