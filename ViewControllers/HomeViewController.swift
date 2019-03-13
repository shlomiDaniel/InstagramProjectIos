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
    
    var sql = ModelSql();
    
    
    
    @IBAction func log_out_button_action(_ sender: Any) {
        SVProgressHUD.show(withStatus: "just a moment")
        if Api.internetApi.IsInternet == true {
            if (Model.instance.modelFirebase.sign_Out()){
                SVProgressHUD.showSuccess(withStatus: "signing out success")
                
                let story_board = UIStoryboard(name: "Main" , bundle : nil)
                let sign_in_vc =  story_board.instantiateViewController(withIdentifier: "SignInView")
                self.present(sign_in_vc, animated: true, completion: nil)
            }else{
                print("error signing out the user")
                SVProgressHUD.showError(withStatus: "error in signing out")
            }
        } // if IsInternet
        else {
                if sql.sign_Out() == true
                {
                    SVProgressHUD.showSuccess(withStatus: "signing out success")
                
                    let story_board = UIStoryboard(name: "Main" , bundle : nil)
                    let sign_in_vc =  story_board.instantiateViewController(withIdentifier: "SignInView")
                    self.present(sign_in_vc, animated: true, completion: nil)
                }
                else
                {
                    print("error signing out the user")
                    SVProgressHUD.showError(withStatus: "error in signing out")
                }
            } // else
        
    }//log_out_button_action

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        
        table_view.dataSource = self
        table_view.estimatedRowHeight = 521
        table_view.rowHeight = UITableView.automaticDimension
        
        
        var name: String? = "";
        
        if Api.internetApi.IsInternet == true {
            name = Model.instance.modelFirebase.getUserName()
        } else
        {
            name = sql.getUserName();
        }
        
        if name != nil{
            let alert = UIAlertController(title: "Welcome", message: "Welcome " + name!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
            
            
            Model.instance.modelFirebase.users.removeAll()
            Model.instance.modelFirebase.posts.removeAll()
        }
    }//viewDidLoad
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Model.instance.modelFirebase.users.removeAll()
        Model.instance.modelFirebase.posts.removeAll()
        
        if Api.internetApi.IsInternet == true {
            Model.instance.modelFirebase.loadPost(table_view: table_view)
        } else
        {
            sql.loadUser();
            sql.loadPost(table_view: table_view);
        }
        self.tabBarController?.tabBar.isHidden = false
        //Model.instance.modelFirebase.posts.removeAll()
    } //viewDidAppear
    
    
    
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
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! HomeTableViewCell
        
        let post = Model.instance.modelFirebase.posts[indexPath.row];
        var user = User();
        if Api.internetApi.IsInternet == true {
            user = Model.instance.modelFirebase.users[indexPath.row]
        } else {
            //print ("DEBUG: POST: \(post.id), \(post.image_url), \(post.isLike), \(post.numberOfLikes), \(post.text_share), \(post.uid)");
            user = sql.getUser(uid: post.uid!);
        } // else
        
        table_view.rowHeight = 450;
        cell.text_post_label.numberOfLines = 0;
        
        cell.user = user
        cell.post = post
        cell.delegate = self
        
        return cell
    }//tableView
    
    
}
extension HomeViewController : HomeTableViewCellDelegate{
    func to_profile_user_vc(userid: String) {
        performSegue(withIdentifier: "home_to_profile_segue", sender: userid)
    }
    
    
    func go_to_comment_vc(post_id: String) {
        performSegue(withIdentifier: "commentSegue", sender: post_id)
    }
    
}
