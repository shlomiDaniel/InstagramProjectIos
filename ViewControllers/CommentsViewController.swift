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

    @IBOutlet weak var table_view: UITableView!
    @IBOutlet weak var send_button_iboutlet: UIButton!
    @IBOutlet weak var comment_text: UITextField!
    let post_id = ""
    
    
    var commets = [Comment]()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table_view.dataSource = self
        table_view.estimatedRowHeight = 80
        
        
      send_button_iboutlet.isEnabled = false
        empty()
        hadle_text_filed()
        
    }
    
    func loadComments(){
        let post_comments_ref = Database.database().reference().child("post_comments").child(self.post_id)
        post_comments_ref.observe(.childAdded, with: {
            snapshot in
                Database.database().reference().child("comments").child(snapshot.key)
                    .observeSingleEvent(of: .value, with: {
                        snapshot_comment in
                        print(snapshot_comment.value)
                        
                            if let dictionary = snapshot_comment.value as? [String : Any]{
                                var new_comment = Comment.transformCommet(dictionary: dictionary)
                                Model.instance.modelFirebase.fetchUser(uid: new_comment.uid!)
                                Model.instance.modelFirebase.comments.append(new_comment)
                                self.table_view.reloadData()
                                
                            }
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
    
    @IBAction func sendButton(_ sender: Any) {
        let ref = Database.database().reference()
        let comment_ref = ref.child("posts")
        let new_commet_id  = comment_ref.childByAutoId().key
        let new_comment_ref = comment_ref.child(new_commet_id!)
        var uid  = Auth.auth().currentUser?.uid
        
        new_comment_ref.setValue(["uid" : uid,"commentText" : comment_text.text! ]) { (error, ref) in
            if error != nil
            {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            self.empty()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension CommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.instance.modelFirebase.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = table_view.dequeueReusableCell(withIdentifier: "post_cell", for: indexPath) as! commentsTableViewCell
        
        let comment = Model.instance.modelFirebase.comments[indexPath.row]
        let user = Model.instance.modelFirebase.users[indexPath.row]
        table_view.rowHeight = 450
       
        cell.user = user
        cell.comment = comment
        
       
        return cell
    }
    
    
    
    
}
