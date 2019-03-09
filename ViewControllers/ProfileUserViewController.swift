//
//  ProfileUserViewController.swift
//  InstagramApplication
//
//  Created by admin on 04/03/2019.
//  Copyright © 2019 SHLOMI. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileUserViewController: UIViewController {

    @IBOutlet weak var collection_view: UICollectionView!
    var posts :  [Post] = []
    var user : User!
    var user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        collection_view.dataSource = self
        collection_view.delegate = self
        fetch_user()
        feth_my_post()
    }
    
    func fetch_user(){
        Api.User.observeUser(withId: user_id) { (user) in
            self.user = user
            self.title = user.userName
            self.collection_view.reloadData()
        }
       
    }
        
        func feth_my_post(){
           
            Api.my_posts.REF_POSTS.child(user_id).observe(.childAdded) { (snapshot) in
                Api.post.observePost(withId: snapshot.key, complition: {
                    (post) in
                    
                    self.posts.append(post)
                    self.collection_view.reloadData()
                })
            }
            
        }


}


    extension ProfileUserViewController : UICollectionViewDataSource{
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
            // header_cell.backgroundColor = UIColor.red
            //header_cell.update_view()
            if let user = self.user{
                header_cell.user = user
            }
            return header_cell
        }
    }
    extension ProfileUserViewController : UICollectionViewDelegateFlowLayout{
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

