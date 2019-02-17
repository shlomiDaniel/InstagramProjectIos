//
//  ProfileViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user : User!
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collection_view.dataSource = self
        fetch_user()
    }
    

    func fetch_user(){
        Api.User.observe_currect_user { (user) in
            self.user = user
            self.collection_view.reloadData()
            
        }

}


    
    //self.user = user
  //  self.collec
        
    
    
    
}

extension ProfileViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)
    return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header_cell = collectionView.dequeueReusableSupplementaryView(ofKind : UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerProfileCollectionReusableView", for: indexPath)
            as! headerProfileCollectionReusableView
       // header_cell.backgroundColor = UIColor.red
        //header_cell.update_view()
        if let user = self.user{
            header_cell.user = user
        }
        return header_cell
    }
}
