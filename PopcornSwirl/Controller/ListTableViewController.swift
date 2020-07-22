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
    
    var mediaList = [Media]()
    var filteredList = [Media]()
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let indexPath = IndexPath(row: 0, section: 0)
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44.0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        filterData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData() {
        mediaList.removeAll()
        let managedMediaList = DataManager.shared.fetchMediaHistory()!
        print(managedMediaList.count)
        for managedMedia in managedMediaList {
            MediaService.getMedia(id: managedMedia.id) { (success, media) in
                if success, let media = media {
                    media.viewed = managedMedia.viewed
                    media.bookmark = managedMedia.bookmark
                    media.notes = managedMedia.notes
                    self.mediaList.append(media)
                } else {
                    //self.presentNoDataAlert(title: "Oops...", message: "No Data")
                }
            }
        }
    }
    
    func filterData() {
        let segment = segmentControl.selectedSegmentIndex
        switch segment {
        case 0:
            filteredList = mediaList.filter{ $0.bookmark == true }
        case 1:
            filteredList = mediaList.filter{ $0.viewed == true }
        case 2:
            filteredList = mediaList.filter{ $0.notes != "" }
        default:
            filteredList = mediaList
        }
    }
    @IBAction func segmentValueChanged(_ sender: Any) {
        filterData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
               case 0:
                    return 1
               default:
                    return filteredList.count
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "filmCell")! as! ListTableViewCell
            cell.populate(media: filteredList[indexPath.row])
            if let imageURL = URL(string: filteredList[indexPath.row].posterPath) {
                MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                    if success, let imageData = imageData,
                        let artwork = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            cell.setImage(image: artwork)
                        }
                    }
                    
                })
            }
            return cell
        }
        

    }
}
