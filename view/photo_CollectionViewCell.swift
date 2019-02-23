//
//  photo_CollectionViewCell.swift
//  InstagramApplication
//
//  Created by SHLOMI on 15 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class photo_CollectionViewCell: UICollectionViewCell {
    
    
    
    
    @IBOutlet weak var photo: UIImageView!
    var post : Post?{
    didSet{
    update_view()
    
    
    }
    }
    func update_view(){
        if let photo_url_string = post?.image_url
        {
            let photo_url = URL(string: photo_url_string)
            //self.photo_
            self.photo.sd_setImage(with: photo_url, placeholderImage: UIImage())
           // self.i.sd_setImage(with: photo_url, placeholderImage: UIImage())
        }
    }
}
