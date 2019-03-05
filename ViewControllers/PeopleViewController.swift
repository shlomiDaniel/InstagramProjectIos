//
//  PeopleViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 15 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var table_view: UITableView!
    
    var users : [User] = []
    //var delegate : pepole_TableViewCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        Model.instance.modelFirebase.users.removeAll()
        
        table_view.clearsContextBeforeDrawing = true
        // self.table_view.reloadData()
        
          loadUsers()
        table_view.reloadData()
    }
    
    func loadUsers(){

        Api.User.observeUser_with_child_added_event { (user) in
            self.is_following(user_id : user.id, completed: {
                (value) in
                user.is_following = value
                Model.instance.modelFirebase.users.append(user)
                self.table_view.reloadData()
            })
            
//
        }
        
        
    }
    func is_following(user_id : String,completed : @escaping (Bool)->Void){        
        
        Api.follow.is_following(user_id: user_id, completed: completed)
    }

}

extension PeopleViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Model.instance.modelFirebase.users.count)
        return Model.instance.modelFirebase.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = table_view.dequeueReusableCell(withIdentifier: "pepole_TableViewCell", for: indexPath) as! pepole_TableViewCell
        let user = Model.instance.modelFirebase.users[indexPath.row]
        cell.delegate = self
       
        
        
        cell.user = user
      

        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProfileSegue"
        {
            let peopleVC = segue.destination as! ProfileUserViewController
            let user_id = sender as! String
            
            peopleVC.user_id = user_id
        }
    }
    
    
    
    
}
extension PeopleViewController : pepole_TableViewCellDelegate{
    func go_to_profile_user_vc(user_id: String) {
        performSegue(withIdentifier: "ProfileSegue", sender: user_id)
    }
    
    
    
}
