//
//  headerProfileCollectionReusableView.swift
//  InstagramApplication
//
//  Created by SHLOMI on 12 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class headerProfileCollectionReusableView: UICollectionReusableView {
    
    
    var user : User?{
        
        didSet{
            update_view()
        }
    }
    
    
    @IBOutlet weak var folowing_count_label: UILabel!
    @IBOutlet weak var followers_count_label: UILabel!
    @IBOutlet weak var my_post_count_label: UIView!
    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var profile_image: UIImageView!
   
    func update_view(){
    
        self.name_label.text = user!.userName
        if let photo_url_string = user?.profile_image_url
        {
            let photo_url = URL(string: photo_url_string)
            
            self.profile_image.sd_setImage(with: photo_url, placeholderImage: UIImage(named: "download"))
        }
        }
    
    }
    

