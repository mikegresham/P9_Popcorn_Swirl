//
//  ListTableViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 19/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let indexPath = IndexPath(row: 0, section: 0)
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
               case 0:
                   return 1
               default:
                   return 5
               }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell")!
            return cell
        }

    }
}
