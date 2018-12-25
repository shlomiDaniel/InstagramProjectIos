//
//  HomeTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 17 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

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
        // Initialization code
    }
    @IBOutlet weak var share_image: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
