//
//  NewUserViewController.swift
//  InstagramApplication
//
//  Created by admin on 20/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var idTxt: UITextField!
    
    
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var nametxt: UITextField!
    
    @IBAction func saveButtonTxt(_ sender: Any) {
       //let us = User(_id: idTxt.text!, _name: nametxt.text!, _userName: userNameTxt.text!, _password: passwordTxt.text!)
        let us = User(_id: idTxt.text!, _userName: nametxt.text!, _password: passwordTxt.text!, _email: userNameTxt.text!);
        Model.instance.modelFirebase.addNewUser(user: us)
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
