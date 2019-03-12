//
//  commentsTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 6 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
protocol commentsTableViewCellDelegate {
   
    func to_profile_user_vc(userid :String)
}

class commentsTableViewCell: UITableViewCell {

    var user : User?{
        didSet {
            setUserInfo()
        }
    }
    var comment : Comment?{
        didSet {
            updateView()
        }
    }
    var delegate : commentsTableViewCellDelegate?
    
    @IBOutlet weak var profile_image_view: UIImageView!
    
    
    @IBOutlet weak var username_label: UILabel!
    
    @IBOutlet weak var comment_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        username_label.text = ""
        comment_label.text = ""

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profile_user_Touch))
        username_label.isUserInteractionEnabled = true
        username_label.addGestureRecognizer(tapGestureRecognizer)
      
    }
    
    @objc func profile_user_Touch(){
        print("helloworld")
        if let user_id = user?.id{
            
            delegate?.to_profile_user_vc(userid: user_id)
        }
        

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profile_image_view.image = UIImage(named: "download")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    func updateView(){
        comment_label.text = comment?.comment_text
        
    }
    func setUserInfo(){
        username_label.text = user?.userName
        if let photo_url_string = user?.profile_image_url
        {
            let photo_url = URL(string: photo_url_string)
            
            self.profile_image_view.sd_setImage(with: photo_url, placeholderImage: UIImage(named: "download"))
        }
    }

}
