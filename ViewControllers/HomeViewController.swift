//
//  HomeViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var logOut_button: UIBarButtonItem!
    @IBOutlet weak var table_view: UITableView!
    var data = [User]()
    var selectedId : String?
    
  
    
    @IBAction func log_out_button_action(_ sender: Any) {
        SVProgressHUD.show(withStatus: "just a moment")
        if (Model.instance.modelFirebase.sign_Out()){
            SVProgressHUD.showSuccess(withStatus: "signing out success")
            
            let story_board = UIStoryboard(name: "Main" , bundle : nil)
            let sign_in_vc =  story_board.instantiateViewController(withIdentifier: "SignInView")
            self.present(sign_in_vc, animated: true, completion: nil)
        }else{
            print("error signing out the user")
            SVProgressHUD.showError(withStatus: "error in signing out")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   Model.instance.modelFirebase.users.removeAll()
        //check it may cases crashed ///////////////////
        Model.instance.modelFirebase.posts.removeAll()
         table_view.dataSource = self
        table_view.estimatedRowHeight = 521
        table_view.rowHeight = UITableView.automaticDimension
        
        let name = Model.instance.modelFirebase.getUserName()
        if name != nil{
            let alert = UIAlertController(title: "Welcome", message: "Welcome " + name!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
            
            
            
            Model.instance.modelFirebase.loadPost(table_view: table_view)
          
            
        }
   }
    override func viewDidAppear(_ animated: Bool) {
        Model.instance.modelFirebase.users.removeAll()
         Model.instance.modelFirebase.posts.removeAll()
        Model.instance.modelFirebase.loadPost(table_view: table_view)
        //Model.instance.modelFirebase.posts.removeAll()
    }
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue"
        {
            let comment_vc = segue.destination as! CommentsViewController
            let post_id = sender as! String
            comment_vc.post_id = post_id
        }
        //check
        if segue.identifier == "home_to_profile_segue"
        {
            let profile_vc = segue.destination as! ProfileUserViewController
            let user_id = sender as! String
            
            profile_vc.user_id = user_id
        }
    }

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.instance.modelFirebase.posts.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = table_view.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! HomeTableViewCell
        print(indexPath.row)
      
        
        
//                let post = Model.instance.modelFirebase.posts[indexPath.row]
//                let user = Model.instance.modelFirebase.users[indexPath.row]
//                table_view.rowHeight = 450
//                cell.text_post_label.numberOfLines = 0
//
//                    cell.user = user
//                    cell.post = post
//                    cell.delegate = self
        
               // cell.delegate = self
                
        

        let post = Model.instance.modelFirebase.posts[indexPath.row]
        let user = Model.instance.modelFirebase.users[indexPath.row]
        table_view.rowHeight = 450
        cell.text_post_label.numberOfLines = 0
        cell.user = user
        cell.post = post
        cell.homeVc = self
        

        return cell
    }


    
//    override func viewDidAppear(_ animated: Bool) {
//
//    }
}
extension HomeViewController : HomeTableViewCellDelegate{
    func to_profile_user_vc(userid: String) {
       performSegue(withIdentifier: "home_to_profile_segue", sender: userid)
    }
    
    
    func go_to_comment_vc(post_id: String) {
         performSegue(withIdentifier: "commentSegue", sender: post_id)
    }
    
}
