//
//  UserDetailsViewController.swift
//  InstagramApplication
//
//  Created by admin on 20/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    var userId : String?
    var user : User?
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if userId != nil{
            //user = Model.instance.modelFirebase.getUser(byId: userId!)
            //nameLabel.text = user?.name
        }
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
