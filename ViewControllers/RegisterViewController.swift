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

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var username_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    
    var image_selected : UIImage?
    var model = Model.instance.modelFirebase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        myImageView.isUserInteractionEnabled = true
        myImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    let imagePicker = UIImagePickerController()
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImagew = tapGestureRecognizer.view as! UIImageView
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func dismmis(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as! UIImage?{
            myImageView.image = image
            image_selected = image
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "registerToTabBar" {
            if email_txt.text! == "" || password_txt.text! == "" {
                let alert = UIAlertController(title: "Error Registering", message: "Password or Email are missing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                SVProgressHUD.showError(withStatus: "Error Registering")
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            model.regiser_new_user(mail: email_txt.text!, pass: password_txt.text!) { (success) in
                if (success!){
                    
                    self.performSegue(withIdentifier: "registerToTabBar", sender: self)
                    SVProgressHUD.show(withStatus: "just a momment")
                

                    
                    var image_url = self.model.saveImage(image: self.image_selected!, name: "image", child: "profile_image", text: "", callback: { (url) in
                        
                        })
                    self.model.add_new_user(email: self.email_txt.text!, pass:  self.password_txt.text!, userName: self.username_txt.text!, url: image_url)
                SVProgressHUD.showSuccess(withStatus: "Register success")
                    
             
                }else{
                    let alert = UIAlertController(title: "Error Registering", message: "User already exists", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        return false
    }
}
