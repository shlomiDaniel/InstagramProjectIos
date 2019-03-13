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

protocol HomeTableViewCellDelegate {
    func go_to_comment_vc(post_id : String)
    func to_profile_user_vc(userid :String)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var post_image: UIImageView!
    @IBOutlet weak var like_image: UIImageView!
    @IBOutlet weak var comment_image: UIImageView!
    @IBOutlet weak var like_button: UIButton!
    @IBOutlet weak var text_post_label: UILabel!
    @IBOutlet weak var num_of_likes_label: UILabel!
    var delegate : HomeTableViewCellDelegate?
    var postRef : DatabaseReference!
    var homeVc : HomeViewController?
    let sql = ModelSql();
    
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
     
        let tap_gesture_name = UITapGestureRecognizer(target: self, action: #selector(self.profile_user_Touch))
        name_label.addGestureRecognizer(tap_gesture_name)
        name_label.isUserInteractionEnabled = true
       
    }
    
    @objc func commentImageView_Tocuch(){
        if Api.internetApi.IsInternet == true {
            //print("DEBUG: HomeTableViewCell.commentImageView_Tocuch")
            if let id = post?.id{
               delegate?.go_to_comment_vc(post_id: id)
            }
        }
        else{
            print ("Comments are not shown while internet is not awailable...")
        }
    }
    
    @objc func profile_user_Touch(){
        print("DEBUG: HomeTableViewCell.profile_user_Touch")
        if let user_id = user?.id{
            delegate?.to_profile_user_vc(userid: user_id)
        }
        
    }
    @objc func likeImageViewTouch(){
        if Api.internetApi.IsInternet == true {
            postRef = Api.post.REF_POSTS.child(post!.id!)
            increasmentLikes(forRef : postRef!)
        }
        else
        {
            print ("DEBUG: HomeTableViewCell.likeImageViewTouch is not supported while internet is off...")
        }
        
    }
    
    func increasmentLikes(forRef  ref:DatabaseReference){
        ref.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = Auth.auth().currentUser?.uid {
                print("post 1:\(post)")
                var likes: Dictionary<String, Bool>
                likes = post["likes"] as? [String : Bool] ?? [:]
                var likeCount = post["likeCount"] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post["likeCount"] = likeCount as AnyObject?
                post["likes"] = likes as AnyObject?
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
            //print ("DEBUG updateView: photo_url = \(photo_url!)");
            
            if Api.internetApi.IsInternet == true {
                self.post_image.sd_setImage(with: photo_url, placeholderImage: UIImage())
                Api.post.REF_POSTS.child(post!.id!).observeSingleEvent(of: .childChanged) { (snapshot) in
                    if let dict = snapshot.value as? [String:Any]{
                        let post = Post.transformPostPhoto(dictionary: dict, key: snapshot.key)
                    }
                } //(snapshot) in
            }
            else
            { // No Internet
                
                var documentsUrl: URL {
                    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                }
                let fileURL = documentsUrl.appendingPathComponent(String(photo_url_string.dropFirst(11)));
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    //print ("DEBUG: fileURL = \(fileURL)")
                    self.post_image.image =  UIImage(data: imageData)
                } catch {
                    print("Error loading image : \(error)")
                }
            } // else NoInsternet
            
        self.updateLike(post: post!)
 
        }
    }//updateView
    
    func updateLike(post : Post){
       let image_name = post.likes == nil || !post.isLike! ? "icons8-heart-outline-35" : "icons8-heart-outline-3S5"
           like_image.image = UIImage(named: image_name)
        //print("DEBUG: HomeTableViewCell.updateLike: \(post.numberOfLikes!)")
        if let count  = post.numberOfLikes , count != 0{
            //print("like")
            //print(count)
            like_button.setTitle("\(count) likes", for: UIControl.State.normal)
        }else if post.numberOfLikes == 0{
            //print("not like")
            like_button.setTitle("be first to like", for: UIControl.State.normal)
        }
        
    }
    
    func setUserInfo(){
        
        if (Api.internetApi.IsInternet == true) {
                        self.name_label.text = user?.userName
    //        print ("DEBUG: HomeTableViewCell.setUserInfo: name_label.text = \(name_label.text!)")
            if let uid = post?.uid{
                Model.instance.modelFirebase.ref.child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                    snapshot in
                    if let dictionary = snapshot.value as? [String : Any]{
                        let user = User.transformUserInfo(dict: dictionary,key: snapshot.key)
                        self.name_label.text = user.userName
                        print(self.name_label.text!)
                        if let photo_url_string = user.profile_image_url
                        {
                            let photo_url = URL(string: photo_url_string)
    //                        print ("DEBUG: HomeTableViewCell.setUserInfo: proho_url = \(photo_url!)");
                            self.profile_image.sd_setImage(with: photo_url)
                        }
                    }
                })
            }
        }// if isInternet
        else {
            if let uid = post?.uid {
                let photo_url_string = sql.getUser(uid: uid).profile_image_url;
                self.name_label.text = sql.getUser(uid: uid).userName;
             
                var documentsUrl: URL {
                    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                }
                let fileURL = documentsUrl.appendingPathComponent(String((photo_url_string?.dropFirst(11))!));
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    print ("DEBUG: fileURL = \(fileURL)")
                    self.profile_image.image =  UIImage(data: imageData)
                } catch {
                    print("Error loading image : \(error)")
                }
            }
            
            
            
            
            
            
        } // else is Isternet
    } //setUserInfo
    
    @IBOutlet weak var share_image: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profile_image.image = UIImage(named: "download")
    }

}
