//
//  HomeTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 17 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var post_image: UIImageView!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var like_image: UIImageView!
    @IBOutlet weak var comment_image: UIImageView!
    @IBOutlet weak var like_button: UIButton!
    @IBOutlet weak var text_post_label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
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
    
    func updateView(){
       
    text_post_label.text = post?.text_share
       
        if let photo_url_string = post?.image_url
        {
            let photo_url = URL(string: photo_url_string)
          
            self.post_image.sd_setImage(with: photo_url, placeholderImage: UIImage())
        }
        
    }
    func setUserInfo(){
        if let uid = post?.uid{
            Model.instance.modelFirebase.ref.child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dictionary = snapshot.value as? [String : Any]{
                    var user = User.transformUserInfo(dict: dictionary)
                    self.name_label.text = user.userName
                    
                     print("im here")
                    
                    if let photo_url_string = user.profile_image_url
                    {
                        let photo_url = URL(string: photo_url_string)
                        
                        self.profile_image.sd_setImage(with: photo_url, placeholderImage: UIImage())
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
