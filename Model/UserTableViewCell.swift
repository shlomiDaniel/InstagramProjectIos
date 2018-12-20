//
//  UserTableViewCell.swift
//  InstagramApplication
//
//  Created by admin on 20/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation
import UIKit
class UserTableViewCell : UITableViewCell {
    
    @IBOutlet weak var profile_image: UIImageView!
    
    @IBOutlet weak var textCell: UITextView!
    
    @IBOutlet weak var userButoon: UIButton!
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAddUser(_ sender: Any) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func userDetailsButton(_ sender: Any) {
        
        
    }
    
}
