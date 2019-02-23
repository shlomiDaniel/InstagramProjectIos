//
//  HomeTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 17 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var post_image: UIImageView!
    //@IBOutlet weak var profile_image: UIImageView!
    //@IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var like_image: UIImageView!
    @IBOutlet weak var comment_image: UIImageView!
    @IBOutlet weak var like_button: UIButton!
    @IBOutlet weak var text_post_label: UILabel!
    //check
    @IBOutlet weak var num_of_likes_label: UILabel!
    var postRef : DatabaseReference!
    var homeVc : HomeViewController?
    
    var post : Post?{
        didSet{
            updateView()
        }
    }
    
    var user : User?{
        didSet {
            setUserInfo()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        name_label.text = ""
        text_post_label.text = ""
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_Tocuch))
        comment_image.isUserInteractionEnabled = true
        comment_image.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureLike = UITapGestureRecognizer(target: self, action: #selector(self.likeImageViewTouch))
        like_image.isUserInteractionEnabled = true
        like_image.addGestureRecognizer(tapGestureLike)
       
    }
    
    @objc func commentImageView_Tocuch(){
        print("helloworld")
        if let id = post?.id{
            homeVc?.performSegue(withIdentifier: "commentSegue", sender: id)

        }
        
    }
    @objc func likeImageViewTouch(){
       postRef = Api.post.REF_POSTS.child(post!.id!)
        increasmentLikes(forRef : postRef!)
        
    }
    
    func increasmentLikes(forRef  ref:DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                print("post 1:\(post)")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    // Unstar the post and remove self from stars
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    // Star the post and add self to stars
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
                
                // Set value and report transaction success
                currentData.value = post
                
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let dict = snapshot?.value as? [String : Any]{
                let post = Post.transformPostPhoto(dictionary: dict, key: snapshot!.key)
                self.updateLike(post: post)
            }
            
        }
        
    }
    
    func updateView(){
       
    text_post_label.text = post?.text_share
       
        if let photo_url_string = post?.image_url
        {
            let photo_url = URL(string: photo_url_string)
          
            self.post_image.sd_setImage(with: photo_url, placeholderImage: UIImage())
        }
        Api.post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .childChanged) { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
            }
        }
     //updateLike(post : post!)
        Api.post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .childChanged) { (snapshot) in
            if let value = snapshot.value as? Int{
                self.like_button.setTitle("\(value) likes", for: UIControl.State.normal)
            }
            
        }
        
    }
    
    func updateLike(post : Post){
        //post.numberOfLikes = 1
       let image_name = post.likes == nil || !post.isLike! ? "icons8-heart-outline-35" : "icons8-heart-outline-3S5"

           like_image.image = UIImage(named: image_name)
        print(post.numberOfLikes)
        if let count  = post.numberOfLikes , count != 0{
            print("like")
            print(count)
            like_button.setTitle("\(count) likes", for: UIControl.State.normal)
            
        }else if post.numberOfLikes == 0{
            print("not like")
            
           // print(count)
            like_button.setTitle("be first to like", for: UIControl.State.normal)
        }
        
        
    }
    
    func setUserInfo(){
        self.name_label.text = user?.userName
        if let uid = post?.uid{
            Model.instance.modelFirebase.ref.child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dictionary = snapshot.value as? [String : Any]{
                    var user = User.transformUserInfo(dict: dictionary,key: snapshot.key)
                    self.name_label.text = user.userName

                     print("im here")
                     print(self.name_label.text)
                   // self.name_label.text = user.userName
                    if let photo_url_string = user.profile_image_url
                    {
                        let photo_url = URL(string: photo_url_string)

                        self.profile_image.sd_setImage(with: photo_url)
                   }
                  
                }
            })
        }
      
        
        
    }
    @IBOutlet weak var share_image: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profile_image.image = UIImage(named: "download")
    }

}
