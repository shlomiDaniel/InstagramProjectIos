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
            if email_txt.text! == "" || password_txt.text! == "" ||  username_txt.text! == "" {
                let alert = UIAlertController(title: "Error Registering", message: "User or Password or Email are missing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
                
                self.present(alert, animated: true, completion: nil)
                return false
            }
            
            model.regiser_new_user(mail: email_txt.text!, pass: password_txt.text!,userName: username_txt.text!) { (success) in
                if (success!){
                    self.performSegue(withIdentifier: "registerToTabBar", sender: self)
                    //        model.saveImage(image : image_selected!, name: name) { (name) in
                    //
                    //        }
                    
                    //            let userRef = Database.database().reference().child("users").childByAutoId()
                    //            //print(self.ref.description()) : https://instagramfirebase-6b380.firebaseio.com/users
                    //            let user = Auth.auth().currentUser!
                    //            let userID = user.uid
                    //            let newUserRef = userRef.child(userID)
                    
                    
                    //            let storageRef = Storage.storage().reference(forURL: "gs://instagramfirebase-6b380.appspot.com").child("profile_image").child(userID)
                    //          //  newUserRef.setValue(["userName": self.username_txt.text! , "email" : self.email_txt.text!])
                    //
                    //            if let profileImage =  self.image_selected!.jpegData(compressionQuality: 0.1){
                    //                storageRef.putData(profileImage, metadata: nil, completion: {
                    //                    (StorageMetadata, error) in
                    //
                    //                    if error == nil {
                    //                        // success image is uploaded
                    //                        storageRef.downloadURL { url, error in
                    //                            // success!
                    //                            let image_url = url?.absoluteURL
                    //                            print(image_url)
                    //                            newUserRef.setValue(["userName": self.username_txt.text! , "email" : self.email_txt.text!,"profile_image_url" : image_url?.absoluteString])
                    //                            //let newuserref = Database.database().reference().child("users").child(
                    //                            //newuserref.setValue([ "profile_pic" :  image_url ])
                    //                        }
                    //                    } else {
                    //                        // failed to upload image
                    //                    }
                    //                })
                    //            }
                    //
                    
                    //                @IBAction func dismissPage(_ sender: Any) {
                    //                    self.dismiss(animated: true, completion: nil)
                    //                }
                    
                    
                    //    @IBAction func profileImageButton(_ sender: Any) {
                    //
                    //
                    //
                    //        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
                    //            picker.allowsEditing = false
                    //            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
                    //            present(picker, animated: true, completion: nil)
                    //        }
                    //
                    //
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
