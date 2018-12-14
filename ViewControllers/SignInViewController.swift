//
//  SignInViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    var fireBaseDataBase = ModelFireBase()
    
    @IBOutlet weak var emailtxt: UITextField!
   
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var password_txt: UITextField!
    @IBOutlet weak var sign_in_button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signInButtonAction(_ sender: Any) {
        fireBaseDataBase.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!)
       // fireBaseDataBase.signInByEmailAndPass(email:emailtxt.text! , pass: password_txt.text!)
        //fireBaseDataBase.s
       // fireBaseDataBase.signInByEmailAndPass(email:emailtxt.text!, pass: password_txt.text!)
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
