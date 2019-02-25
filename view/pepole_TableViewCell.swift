//
//  pepole_TableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 15 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class pepole_TableViewCell: UITableViewCell {

    var user : User?{
        didSet{
           update_view()
        }
    }
    
    
    
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var follow_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure_follow_button(){
        follow_button.backgroundColor = UIColor.green
        follow_button.layer.borderColor = UIColor.white.cgColor
        follow_button.layer.borderWidth = 1.0
        follow_button.layer.cornerRadius = 5.0
        follow_button.tintColor = UIColor.black
         follow_button.addTarget(self, action: #selector(self.follow_presset), for: UIControl.Event.touchUpInside)

        self.follow_button.setTitle("Follow", for: UIControl.State.normal)

        
    }
    func configure_unfollow_button(){
        follow_button.backgroundColor = UIColor.green
        follow_button.layer.borderColor = UIColor.white.cgColor
        follow_button.layer.borderWidth = 1.0
        follow_button.layer.cornerRadius = 5.0
        follow_button.tintColor = UIColor.black
        follow_button.addTarget(self, action: #selector(self.unfollow_presset), for: UIControl.Event.touchUpInside)

        self.follow_button.setTitle("Following", for: UIControl.State.normal)

        
    }
    
    
    func update_view(){
        name_label.text = user?.userName
        if let photo_url_string = user?.profile_image_url
        {
            let photo_url = URL(string: photo_url_string)
            
            self.profile_image.sd_setImage(with: photo_url)
        }
        
        Api.follow.is_following(user_id: user!.id) { (value) in
            if (value){
                self.configure_unfollow_button()
            }else{
                self.configure_follow_button()
            }
            
        }
        
    }

    
    @objc func follow_presset(){
        if user!.is_following == false{
            Api.follow.follow_action(with_user: user!.id)
            configure_unfollow_button()
            user!.is_following = true
        }
        //Api.follow.follow_action(with_user: user!.id)
 //user!.is_following = true
        
    }
    @objc func unfollow_presset(){
        if user!.is_following == true{
            Api.follow.unfollow_action(with_user: user!.id)
            configure_follow_button()
            user!.is_following = false

        }
      //  user!.is_following == false
              //     Api.follow.unfollow_action(with_user: user!.id)

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
