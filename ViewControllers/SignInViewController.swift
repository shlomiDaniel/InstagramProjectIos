//
//  SignInViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

 //    var model = Model.instance.modelFireBase
    
    @IBOutlet weak var emailtxt: UITextField!
   
    @IBOutlet weak var password_txt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func sign_In_Button(_ sender: Any) {
        
        Model.instance.modelFirebase.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!)
       
        
        //        fireBaseDataBase.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!)
        // fireBaseDataBase.signInByEmailAndPass(email:emailtxt.text! , pass: password_txt.text!)
        //fireBaseDataBase.s
        // fireBaseDataBase.signInByEmailAndPass(email:emailtxt.text!, pass: password_txt.text!)
        //        fireBaseDataBase.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!)
        
        
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
