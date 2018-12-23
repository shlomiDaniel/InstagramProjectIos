//
//  HomeViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var data = [User]()
    var selectedId : String?
    

    @IBAction func log_out_button_action(_ sender: Any) {
        if (Model.instance.modelFirebase.sign_Out()){
            let story_board = UIStoryboard(name: "Main" , bundle : nil)
            let sign_in_vc =  story_board.instantiateViewController(withIdentifier: "SignInView")
            self.present(sign_in_vc, animated: true, completion: nil)
        }else{
            print("error signing out the user")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let name = Model.instance.modelFirebase.getUserName()
        if name != nil{
            let alert = UIAlertController(title: "Welcome", message: "Welcome " + name!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
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
