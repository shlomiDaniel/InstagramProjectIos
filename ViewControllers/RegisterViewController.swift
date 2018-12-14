//
//  RegisterViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseDatabase

class RegisterViewController: UIViewController {

    //var firebaseDataBase : DatabaseReference!
   var fireBaseDataBase = ModelFireBase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
   
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var email_txt: UITextField!
    
    @IBOutlet weak var username_txt: UITextField!
    
    @IBOutlet weak var password_txt: UITextField!
    

    
    @IBAction func dismissPage(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: Any) {
        
        
       fireBaseDataBase.regiser_new_user(mail: email_txt.text!, pass: password_txt.text!)
       
       
    }

           
       // firebaseDataBase.registerNewUser()
  
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

