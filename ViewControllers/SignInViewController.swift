//
//  SignInViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController {
    
    var isLogin : Bool = false
    //var cache = CreateLocalCache();
    var sql = ModelSql();
    
    @IBOutlet weak var emailtxt: UITextField!
    
    @IBOutlet weak var password_txt: UITextField!
    
    @IBAction func showRegisterWindow(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signInToRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
            Api.internetApi.IsInternet = true;
        }else{
            print("Internet Connection not Available!")
            Api.internetApi.IsInternet = false;
        }
        
        CreateLocalCache.init();
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Api.internetApi.IsInternet == true
        {
            if Model.instance.modelFirebase.checkIfSignIn() == true{
                self.performSegue(withIdentifier: "signInToTabBar", sender: self);
            }
        }
        else {
            if sql.checkIfSignIn() == true {
                self.performSegue(withIdentifier: "signInToTabBar", sender: self);
            }
        }
    } //viewDidAppear
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "signInToTabBar" {
            if emailtxt.text! == "" || password_txt.text! == ""{
                let alert = UIAlertController(title: "Error Login", message: "User or Password are missing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("Missing user credentials")
                    SVProgressHUD.showSuccess(withStatus: "error")
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            // Async operation
            SVProgressHUD.show(withStatus: "waiting..")
            if Api.internetApi.IsInternet == true {
                Model.instance.modelFirebase.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!) { (success) in
                    if(success!){
                        SVProgressHUD.showSuccess(withStatus: "success")
                        self.performSegue(withIdentifier: "signInToTabBar", sender: self)
                    }else{
                        let alert = UIAlertController(title: "Error Login", message: "User email or password are incorrect", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }//(success)
            } //IsInternet
            else {
                
                sql.signInByEmailAndPass(email: emailtxt.text!, pass: password_txt.text!) { (success) in
                    if (success!){
                        SVProgressHUD.showSuccess(withStatus: "success")
                        self.performSegue(withIdentifier: "signInToTabBar", sender: self)
                    } else {
                        let alert = UIAlertController(title: "Error Login", message: "User email or password are incorrect", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                        self.present(alert, animated: true, completion: nil)
                    } //else
                }
                //SQL: signInByEmaiLAndPass ()
            } // else
        }
        return false //identifier == "signInToTabBar"
    }//shouldPerformSegue
} // class


extension UIViewController {
    
    
    func displayMsg(title : String?, msg : String,
                    style: UIAlertController.Style = .alert,
                    dontRemindKey : String? = nil) {
        if dontRemindKey != nil,
            UserDefaults.standard.bool(forKey: dontRemindKey!) == true {
            return
        }
        
        let ac = UIAlertController.init(title: title,
                                        message: msg, preferredStyle: style)
        ac.addAction(UIAlertAction.init(title: "OK",
                                        style: .default, handler: nil))
        
        if dontRemindKey != nil {
            ac.addAction(UIAlertAction.init(title: "Don't Remind",
                                            style: .default, handler: { (aa) in
                                                UserDefaults.standard.set(true, forKey: dontRemindKey!)
                                                UserDefaults.standard.synchronize()
            }))
        }
        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
    }
}
