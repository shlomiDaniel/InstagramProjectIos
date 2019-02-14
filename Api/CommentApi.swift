//
//  CommentApi.Swift
//  InstagramApplication
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import Foundation
import Firebase
class CommentApi{
    
    var REF_COMMENT = Database.database().reference().child("comments")
    
    func observeComments(withPostId id : String, complition : @escaping (Comment)-> Void){
        REF_COMMENT.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String : Any]{
                let newComment = Comment.transformCommet(dictionary: dict)
                complition(newComment)
            }
        })
    }
    
    
}
