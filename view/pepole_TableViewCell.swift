//
//  pepole_TableViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 15 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
protocol pepole_TableViewCellDelegate {
    func go_to_profile_user_vc(user_id : String)
    
}
class pepole_TableViewCell: UITableViewCell {

    var user : User?{
        didSet{
           update_view()
        }
    }
 
    var delegate : pepole_TableViewCellDelegate?
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
   // @IBOutlet weak var follow_button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.name_Tocuch))
        name_label.isUserInteractionEnabled = true
        name_label.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func name_Tocuch(){
        if let id = user?.id{
            delegate?.go_to_profile_user_vc(user_id : id)
        }
        
    }
  
    func update_view(){
        name_label.text = user?.userName
        if let photo_url_string = user?.profile_image_url
        {
            let photo_url = URL(string: photo_url_string)
            
            self.profile_image.sd_setImage(with: photo_url)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    

}
