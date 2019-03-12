//
//  searchViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 19 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {
    
    
    var searchResults = [[String : Any]]()
    @IBOutlet weak var table_view: UITableView!
    var search_bar = UISearchBar()
    var users : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        search_bar.delegate = self
     search_bar.searchBarStyle = .minimal
        search_bar.placeholder = "Search"
        search_bar.frame.size.width = view.frame.size.width - 60
        let search_item = UIBarButtonItem(customView: search_bar)
        self.navigationItem.rightBarButtonItem = search_item
        self.table_view.dataSource = self
         // Model.instance.modelFirebase.users.removeAll()
        search()
    }
    
    func search(){
        Model.instance.modelFirebase.users.removeAll()
        if let search_text = search_bar.text?.lowercased(){
            Model.instance.modelFirebase.users.removeAll()
            self.table_view.reloadData()

            Api.User.query_users(withtext: search_text) { (user) in
                self.is_following(user_id : user.id, completed: {
                    (value) in
                    //user.is_following = value
                    Model.instance.modelFirebase.users.append(user)
                    self.table_view.reloadData()
                    
                })
            }
            
        }
        
        Model.instance.modelFirebase.users.removeAll()
        
        table_view.clearsContextBeforeDrawing = true
        // self.table_view.reloadData()
        table_view.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // Model.instance.modelFirebase.users.removeAll()
        
        table_view.clearsContextBeforeDrawing = true
        // self.table_view.reloadData()
        table_view.reloadData()
          //Model.instance.modelFirebase.users.removeAll()

    }
    
    func is_following(user_id : String,completed : @escaping (Bool)->Void){
        
        Api.follow.is_following(user_id: user_id, completed: completed)
    }


}
extension searchViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        search()
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        search()
    }
}
extension searchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Model.instance.modelFirebase.users.count)
        return Model.instance.modelFirebase.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = table_view.dequeueReusableCell(withIdentifier: "pepole_TableViewCell", for: indexPath) as! pepole_TableViewCell
        
        let user = Model.instance.modelFirebase.users[indexPath.row]
        cell.user = user
        
        return cell
    }
    
    
    
    
}
