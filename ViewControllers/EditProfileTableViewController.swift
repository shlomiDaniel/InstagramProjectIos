//
//  EditProfileTableViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 3 Adar II 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//


import UIKit
import SVProgressHUD

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var user_name: UITextField!
    @IBOutlet weak var profile_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.title = "Edit Profile"
        fetch_user()
       
    }
    @IBAction func change_profile_image_button(_ sender: Any) {
        
        let picker_controller = UIImagePickerController()
        picker_controller.delegate = self
        present(picker_controller,animated: true,completion: nil)
        
       
        
        
    }
    @IBAction func log_out_button(_ sender: Any) {
    }
    
    @IBOutlet weak var save_button: UIView!
    // MARK: - Table view data source
    func fetch_user(){
        Api.User.observe_currect_user { (user) in
            self.user_name.text = user.userName
            self.email.text = user.email
            let profile_url = URL(string: user.profile_image_url!)
            self.profile_image.sd_setImage(with: profile_url, placeholderImage: UIImage(named: "download"))
           
        }
      
       
        
    }
    func update_user(user_name : String , email : String , image_data : Data,
                     on_success : @escaping() -> Void,on_erroe : @escaping(_ error_messesge : String?)->Void){
        
       // let currentUser = Auth.auth().currentUser
        
        Api.User.current_user?.updateEmail(to: self.email.text!) { error in
            if let error = error {
                print(error)
            } else {
                print("CHANGED")
                let uid = Api.User.current_user?.uid
                let thisUserRef = Model.instance.modelFirebase.ref.child("users").child(uid!)
                let thisUserEmailRef = thisUserRef.child("email")
                thisUserEmailRef.setValue(self.email.text!)
            }
        }
        let uid = Api.User.current_user?.uid
        let storage_ref = Model.instance.modelFirebase.storageRef.child("profile_image").child(uid!)
        storage_ref.putData(image_data, metadata: nil, completion: ({ (metadata, error) in
            if error != nil {return}
            
            let profile_img = storage_ref.downloadURL(completion: { (url, error) in
                self.set_user_info(profile_imag_url: url!.absoluteString, username: user_name, email: email, uid: uid!, on_success: on_success, on_erroe: on_erroe)
                self.update_data_base(profile_img : url!.absoluteString,user_name : user_name,email: email,on_success : on_success , on_erroe : on_erroe)
            })
        }))

        
    }
    
    func set_user_info(profile_imag_url : String,username:String,email:String,uid : String, on_success : @escaping() -> Void,on_erroe : @escaping(_ error_messesge : String?)->Void){
        let ref = Model.instance.modelFirebase.ref
       
        let user_ref = ref?.child("users")
        let new_user_ref = user_ref?.child(uid)
        new_user_ref?.updateChildValues(["email" : email  , "userName" : username,"user_name_lower_case" : username.lowercased() , "url_profile_image" : profile_imag_url])
        on_success()
    }
    
    func update_data_base(profile_img: String,user_name : String,email: String,on_success : @escaping()->Void , on_erroe : @escaping(_ errorMag:String?)->Void){
         let uidd = Api.User.current_user?.uid
        let dict = ["email" : email  , "userName" : user_name,"user_name_lower_case" : user_name.lowercased() , "url_profile_image" : profile_img]
        Api.User.REF_USER.child(uidd!).updateChildValues(dict) { (error, ref) in
            if error != nil {
                on_erroe("error")
            }else{
                on_success()
            }
        }
    }

    @IBAction func save_buttonn(_ sender: Any) {
        if let profile_image = self.profile_image.image,let imageData = UIImage(named: "download"){
            let png_data = imageData.pngData()
            update_user(user_name: user_name.text!, email: email.text!, image_data: png_data!, on_success: {
                SVProgressHUD.showSuccess(withStatus: "succses")
             let url =   Model.instance.modelFirebase.saveImage(image: profile_image, name: "profile_image", child: "users", text: "", callback: { (url) in
                    print(url)
                print("here")
                
                let ref = Model.instance.modelFirebase.ref
                
                let user_ref = ref?.child("users")
                let uid = Api.User.current_user?.uid
                let new_user_ref = user_ref?.child(uid!)
                new_user_ref?.updateChildValues([ "url_profile_image" : url])
                
                })
            }) { (error_message) in
                SVProgressHUD.showError(withStatus: error_message)
            }
            
        }
        
    }
    
    
}
extension EditProfileTableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage{
            profile_image.image = image
        }
        dismiss(animated: true, completion: nil)
    }
   
    
}
