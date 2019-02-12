//
//  commentsTableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 6 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class commentsTableViewCell: UITableViewCell {

    @IBOutlet weak var profile_image_view: UIImageView!
    @IBOutlet weak var user_name_label: UILabel!
    @IBOutlet weak var comment_labeltxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
