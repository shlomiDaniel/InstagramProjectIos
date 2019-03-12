//
//  DiscoverViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    var posts :  [Post] = []
    @IBOutlet weak var collection_view: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
       collection_view.dataSource = self
        collection_view.delegate = self
        
        self.posts.removeAll()
        // Do any additional setup after loading the view.
    }
    func load_top_posts(){
        self.posts.removeAll()
        Api.post.observe_top_posts { (post) in
            self.posts.append(post)
            self.collection_view.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.posts.removeAll()
        

        load_top_posts()

    }
 

}

extension DiscoverViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoverCollectionViewCell", for: indexPath) as! photo_CollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
   
}
extension DiscoverViewController : UICollectionViewDelegateFlowLayout{
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

