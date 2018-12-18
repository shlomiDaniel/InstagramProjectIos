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
    
    var image_selected : UIImage?
    //var firebaseDataBase : DatabaseReference!
    var fireBaseDataBase = ModelFireBase()
    
    var ref : DatabaseReference!
    
    //FirebaseApp.configure()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        ref = Database.database().reference()
        //var image_selected : UIImage
        
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
            image_selected = image
        }
        //myImageView.image = infoPhoto
    }
    
    
    @IBOutlet weak var email_txt: UITextField!
    
    @IBOutlet weak var username_txt: UITextField!
    
    @IBOutlet weak var password_txt: UITextField!
    
    @IBAction func register(_ sender: Any) {
        //fireBaseDataBase.regiser_new_user(mail: email_txt.text!, pass: password_txt.text!,userName: username_txt.text!)
        
        Auth.auth().createUser(withEmail: email_txt.text!, password: password_txt.text!) { (user, error) in
            if error != nil{
                print("errorrr")
                return
            }
            print("100X")
            print("sign in succes")
            let userRef = self.ref.child("users").childByAutoId()
            //print(self.ref.description()) : https://instagramfirebase-6b380.firebaseio.com/users
            //let uid = user?.Uid
            let userID = Auth.auth().currentUser!.uid
            let newUserRef = userRef.child(userID)
            //newUserRef.setValue(["userName": self.username_txt.text! , "email" : self.email_txt.text!])
            print(newUserRef.description())
            let pic_ref = self.ref.child("users").child("images")
            //pic_ref.setValue(["image": "image" ])
            
            let user = Auth.auth().currentUser!
            let uid = user.uid
            let storageRef = Storage.storage().reference(forURL: "gs://instagramfirebase-6b380.appspot.com").child("profile_image").child(uid)
            newUserRef.setValue(["userName": self.username_txt.text! , "email" : self.email_txt.text!])
            
            if let profileImage =  self.image_selected!.jpegData(compressionQuality: 0.1){
                storageRef.putData(profileImage, metadata: nil, completion: {
                    (StorageMetadata, error) in
                    
                    if error == nil {
                        // success image is uploaded
                        storageRef.downloadURL { url, error in
                            // success!
                            let image_url = url?.absoluteURL
                            print(image_url)
                            
                            //let newuserref = Database.database().reference().child("users").child(
                            //newuserref.setValue([ "profile_pic" :  image_url ])
                        }
                    } else {
                        // failed to upload image
                    }
                })
            }
            
            
            //    @IBAction func dismissPage(_ sender: Any) {
            //        self.dismiss(animated: true, completion: nil)
            //    }
            
            
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
            
            
        }}}




