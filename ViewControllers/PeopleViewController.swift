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
    override func viewDidLoad() {
        super.viewDidLoad()
        //table_view.dataSource = nil
       
     
         //table_view.dataSource = nil
       // table_view.delegate = self
        // Do any additional setup after loading the view.
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
        
        //let post = Model.instance.modelFirebase.posts[indexPath.row]
        let user = Model.instance.modelFirebase.users[indexPath.row]
        //table_view.rowHeight = 450
        cell.user = user
       // cell.text_post_label.numberOfLines = 0
        //
       // tableView.register(UINib(nibName: String(describing: pepole_TableViewCell.self), bundle: nil), forCellReuseIdentifier: "pepole_TableViewCell")

        return cell
    }
    
    
    
    
}
