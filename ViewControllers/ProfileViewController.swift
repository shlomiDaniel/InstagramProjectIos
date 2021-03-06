//
//  ProfileViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import SVProgressHUD
//import Firebase
//import FirebaseAuth

class ProfileViewController: UIViewController {

    var posts :  [Post] = []
    var user : User!
    var sql = ModelSql();
    
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collection_view.dataSource = self
        collection_view.delegate = self
        
        
            fetch_user()
            feth_my_post()
 
        
        //self.title = ""
    }
    
    
    
    @IBAction func edit_profile(_ sender: Any) {
        //Api.internetApi.IsInternet = false
        if Api.internetApi.IsInternet == true{
              performSegue(withIdentifier: "profile_setting_segue", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error Registering", message: "No internet,please connect to the internet to edit profie", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            SVProgressHUD.showError(withStatus: "Error Registering")
            self.present(alert, animated: true, completion: nil)
        }
      
    }
    
    @IBAction func discover(_ sender: Any) {
        
        performSegue(withIdentifier: "to_discover", sender: nil)
        
    }
    func feth_my_post(){
        guard let user  = Api.User.current_user else{
            return
        }
        Api.my_posts.REF_POSTS.child(user.uid).observe(.childAdded) { (snapshot) in
            Api.post.observePost(withId: snapshot.key, complition: {
                (post) in
                
                self.posts.append(post)
                self.collection_view.reloadData()
            })
        }
        
    }

    func fetch_user(){
        if Api.internetApi.IsInternet == true {
            Api.User.observe_currect_user { (user) in
                self.user = user
            }
        }
        else {
            self.user = sql.getUser();
        }
        self.title = user.userName
        self.collection_view.reloadData()
        
        /*
            Api.User.observe_currect_user { (user) in
            self.user = user
            self.title = user.userName
            self.collection_view.reloadData()
        }
        */
}


}

extension ProfileViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo_CollectionViewCell", for: indexPath) as! photo_CollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header_cell = collectionView.dequeueReusableSupplementaryView(ofKind : UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerProfileCollectionReusableView", for: indexPath)
            as! headerProfileCollectionReusableView
       
        if let user = self.user{
            header_cell.user = user
        }
        return header_cell
    }
}
extension ProfileViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collection_view.frame.size.width / 3, height: collection_view.frame.size.width / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
