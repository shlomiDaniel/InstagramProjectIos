//
//  Comment.swift
//  ChameleonFramework
//
//  Created by SHLOMI on 7 Adar I 5779.
//

import Foundation
class Comment{
    
    var FB_id: String?;
    var comment_text : String?
    var uid : String?
    
    init () {
        self.comment_text = "";
        self.uid = "";
    }
    
    init (_uid: String, _comment_text: String)  {
        self.uid = _uid;
        self.comment_text = _comment_text;
    }
    
    init (_FB_id: String, _comment_text: String, _uid: String){
        self.FB_id = _FB_id;
        self.uid = _uid;
        self.comment_text = _comment_text;
    }
    
}
extension Comment{
    static func transformCommet(dictionary : [String : Any]) -> Comment {
        let comment = Comment()
        comment.comment_text = dictionary["comment_text"] as? String
      comment.uid = dictionary["uid"] as? String
        return comment
        
    }
}
