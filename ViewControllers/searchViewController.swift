//
//  searchViewController.swift
//  InstagramApplication
//
//  Created by SHLOMI on 19 Adar I 5779.
//  Copyright © 5779 SHLOMI. All rights reserved.
//

import UIKit

class searchViewController: UIViewController {
    var search_bar = UISearchBar()
    override func viewDidLoad() {
        super.viewDidLoad()
        search_bar.delegate = self
     search_bar.searchBarStyle = .minimal
        search_bar.placeholder = "Serch"
        search_bar.frame.size.width = view.frame.size.width - 60
        let search_item = UIBarButtonItem(customView: search_bar)
        self.navigationItem.rightBarButtonItem = search_item
    }
    


}
extension searchViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
