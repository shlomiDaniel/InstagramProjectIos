//
//  CameraViewController.swift
//  Instagram
//
//  Created by SHLOMI on 2 Tevet 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import SVProgressHUD

class CameraViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var shareButoon: UIButton!
    @IBOutlet weak var remove_button: UIBarButtonItem!
    
    var text : String?
    
    var selectedImage : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        text = textView.text
        //imagePicker.delegate = self
        Model.instance.modelFirebase.users.removeAll()
        Model.instance.modelFirebase.posts.removeAll()
        //Api.internetApi.IsInternet = false
        if Api.internetApi.IsInternet == true{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            photo.isUserInteractionEnabled = true
            photo.addGestureRecognizer(tapGestureRecognizer)
        }else{
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped_no_internet(tapGestureRecognizer:)))
            photo.isUserInteractionEnabled = true
            photo.addGestureRecognizer(tapGestureRecognizer)
            
            
        }
        
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
      button_post_shared()
    }
    
    func button_post_shared() {
        if selectedImage != nil {
            self.shareButoon.isEnabled = true
            self.remove_button.isEnabled = true
            self.shareButoon.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            self.shareButoon.isEnabled = false
             self.remove_button.isEnabled = false
            self.shareButoon.backgroundColor = UIColor.lightGray
        }
    
    }
    
    /////////////////////
    let imagePicker = UIImagePickerController()
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImagew = tapGestureRecognizer.view as! UIImageView
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        // Your action
    }
    
    @objc func imageTapped_no_internet(tapGestureRecognizer: UITapGestureRecognizer)
    {
       
        
        let alert = UIAlertController(title: "Error Registering", message: "No internet,please connect to the internet to edit profie", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        SVProgressHUD.showError(withStatus: "Error Registering")
        self.present(alert, animated: true, completion: nil)
        // Your action
    }
    
    
    //////////////////////////
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        //let originalImage: UIImagePickerController.InfoKey
        if let image = info[.originalImage] as! UIImage?{
            selectedImage = image
            photo.image = image
        }
        //myImageView.image = infoPhoto
    }
//////////////////////////////////////
    @IBAction func shareButtonClick(_ sender: Any) {
        
       
        
       
        let photo_id_string = NSUUID().uuidString
        Model.instance.saveImage(image: selectedImage!, name: "post", child: "posts", text: textView.text!) { (url) in
            
        }
         SVProgressHUD.show(withStatus: "waiting..")
        //SVProgressHUD.showSuccess(withStatus: "upload success")
        cleanScrean()
        self.tabBarController?.selectedIndex = 0
        
//        Model.instance.modelFirebase.users.removeAll()
//        Model.instance.modelFirebase.posts.removeAll()
        
        
    }
    @IBAction func remove_post(_ sender: Any) {
        cleanScrean()
        self.button_post_shared()
    }
    
    func cleanScrean(){
        self.textView.text = ""
        self.photo.image = UIImage(named: "icons8-picture-100")
        self.selectedImage = nil
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "commentSegue"
//        {
//            let comment_vc = segue.destination as! CommentsViewController
//            let post_id = sender as! String
//            comment_vc.post_id = post_id
//        }
//
//    }

}
