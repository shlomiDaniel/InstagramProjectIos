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

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
   
    //var firebaseDataBase : DatabaseReference!
   var fireBaseDataBase = ModelFireBase()
    
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
        let tappedImagew = tapGestureRecognizer.view as! UIImageView
        print("aaaaaaaaaaaaaaaaaaaaaaaaa")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        // Your action
    }
    
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        //let originalImage: UIImagePickerController.InfoKey
        if let image = info[.originalImage] as! UIImage?{
            myImageView.image = image
        }
        //myImageView.image = infoPhoto
    }
    
    
    @IBOutlet weak var email_txt: UITextField!
    
    @IBOutlet weak var username_txt: UITextField!
    
    @IBOutlet weak var password_txt: UITextField!
    
    @IBAction func register(_ sender: Any) {
        
        
        fireBaseDataBase.regiser_new_user(mail: email_txt.text!, pass: password_txt.text!,userName: username_txt.text!)
        
        
    }
    
    @IBAction func dismissPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func profileImageButton(_ sender: Any) {
        
       
//
//        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
//            picker.allowsEditing = false
//            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            present(picker, animated: true, completion: nil)
//
        
//    }
    
    }
    
  
    
}

