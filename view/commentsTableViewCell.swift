//
//  commentsTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 6 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

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
    
    
    @IBOutlet weak var profile_image_view: UIImageView!
    
    
    @IBOutlet weak var username_label: UILabel!
    
    @IBOutlet weak var comment_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // username_label.text = ""
        //comment_label.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateView(){
        comment_label.text = comment?.comment_text
        //username_label.text = comment?.
        
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
