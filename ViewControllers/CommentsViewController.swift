//
//  CommentsViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 6 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import FirebaseAuth

class CommentsViewController: UIViewController {

//    @IBOutlet weak var user_namelabel: UILabel!
    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var send_button_iboutlet: UIButton!
    @IBOutlet weak var comment_text: UITextField!
    var post_id : String!
    
    
    var commets = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
        title = "Comments"
        table_view.dataSource = self
        table_view.estimatedRowHeight = 80
        table_view.rowHeight = UITableView.automaticDimension
        
      send_button_iboutlet.isEnabled = false
        loadComments()
        empty()
        hadle_text_filed()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "commentSegue"
        {
            let comment_vc = segue.destination as! CommentsViewController
            let user_id = sender as! String
            comment_vc.post_id = user_id
        }

    
}
    
    func loadComments(){
        print(print("tryenewcomment"))
        Api.post_Comments.REF_Post_Comments.child(self.post_id)
        .observe(.childAdded, with: {
            snapshot in
            
            Api.Comment.observeComments(withPostId: snapshot.key, complition: {
                comment in
                self.fetchUser(uid: comment.uid!,completed:{
                    self.commets.append(comment)
                    print("newcomment")
                    self.table_view.reloadData()
                    
                })
                
            })
        })
    
    }
    
        
    func hadle_text_filed(){
        comment_text.addTarget(self, action: #selector(self.textfiled_did_changed), for: UIControl.Event.editingChanged)
    }
    
    @objc func textfiled_did_changed(){
        if let coment_text = comment_text.text , !coment_text.isEmpty{
            send_button_iboutlet.setTitleColor(UIColor.black , for: UIControl.State.normal)
            send_button_iboutlet.isEnabled = true
            return
        }
        send_button_iboutlet.setTitleColor(UIColor.lightGray , for: UIControl.State.normal)
        send_button_iboutlet.isEnabled = false

    }
    
    
    
    func fetchUser(uid : String, completed : @escaping()->Void){
        UserApi().observeUser(withId: uid, complition: {
            user in
            self.users.append(user)
            completed()
        })
        
        
    }
    
    
    
    
    @IBAction func sendButton(_ sender: Any) {
        
        //let ref = Database.database().reference()
        let comment_ref = Api.Comment.REF_COMMENT
        let new_commet_id  = comment_ref.childByAutoId().key
        let new_comment_ref = comment_ref.child(new_commet_id!)
        var uid  = Auth.auth().currentUser?.uid
        
        new_comment_ref.setValue(["uid" : uid,"comment_text" : comment_text.text! ]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
         
            let post_comment_ref = Api.post_Comments.REF_Post_Comments.child(self.post_id).child(new_commet_id!)
                post_comment_ref.setValue(true, withCompletionBlock: { (error, ref) in
                if error != nil{
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                }
                     self.empty()
            })
           
           
        }
    }
    func empty(){
        self.comment_text.text = ""
        self.send_button_iboutlet.isEnabled = false
        send_button_iboutlet.setTitleColor(UIColor.lightGray , for: UIControl.State.normal)

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    


}


extension CommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(commets.count)
        return commets.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table_view.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! commentsTableViewCell
      
        let comment = commets[indexPath.row]
        let user = users[indexPath.row]
        table_view.rowHeight = 80
        cell.comment_label.numberOfLines = 0
        cell.user = user
        
        cell.delegate = self
        cell.comment = comment
        
       
        return cell
    }
    
    
    
    
}
extension CommentsViewController : commentsTableViewCellDelegate{
    func to_profile_user_vc(userid: String) {
    performSegue(withIdentifier: "commentSegue", sender: userid)
    }
    
    
    
}
