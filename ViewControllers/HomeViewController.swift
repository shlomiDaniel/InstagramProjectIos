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
         table_view.dataSource = self
        table_view.estimatedRowHeight = 521
        table_view.rowHeight = UITableView.automaticDimension
        let name = Model.instance.modelFirebase.getUserName()
        if name != nil{
            let alert = UIAlertController(title: "Welcome", message: "Welcome " + name!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
            Model.instance.modelFirebase.loadPost(table_view: table_view)
           // table_view.rowHeight = 450
            //table_view.estimatedRowHeight = 520
            
            
            //cell.text_post_label.numberOfLines = 0
            
            
        }
   }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
   
    @IBOutlet weak var logOut_button: UIBarButtonItem!
    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //data = Model.instance.modelFirebase.getAllUsers(callback: <#([User]) -> Void#>)
//      // self.tableView.reloadData()
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell : UserTableViewCell =
//            tableView.dequeueReusableCell(withIdentifier: "UserCell" , for : indexPath) as! UserTableViewCell
//        
//           let us = data[indexPath.row]
//         cell.userNameLabel.text = us.userName
//        return cell
//    }
//
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        NSLog("user select row at \(indexPath.row)")
//        selectedId = data[indexPath.row].id
//        self.performSegue(withIdentifier: "UserDetailsView", sender: self)
//        
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.instance.modelFirebase.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell = table_view.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! HomeTableViewCell
        
        let post = Model.instance.modelFirebase.posts[indexPath.row]
        table_view.rowHeight = 450
        cell.text_post_label.numberOfLines = 0
        cell.post = post
//        cell.profile_image.image = UIImage(named: "ZEUS.jpeg")
//
//        cell.post_image.image = UIImage(named: "ZEUS.jpeg")
//
//
//        cell.name_label.text = "zeus"
//        cell.text_post_label.text = post.text_share
//        if let photo_url_string = post.image_url
//        {
//            let photo_url = URL(string: photo_url_string)
//            cell.post_image.sd_setImage(with : photo_url)
//
//        }
        
        
      //  tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 600
        
//        table_view.h
        return cell
    }


    
    
}
