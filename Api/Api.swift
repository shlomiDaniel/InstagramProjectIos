//
//  Api.swift
//  InstagramApplication
//
//  Created by admin on 14/02/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import Foundation
class Api{
    static var User = UserApi()
    static var post = PostApi()
    static var Comment = CommentApi()
    static var post_Comments = Post_Comments()
    static var my_posts = UserPostApi()
    static var follow = FollowApi()
    static var feed = FeedApi()
}