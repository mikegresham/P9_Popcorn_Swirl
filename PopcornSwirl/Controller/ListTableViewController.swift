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
    
    // MARK: Global Variables
    
    var mediaList = [Film]()
    var filteredList = [Film]()
    var indicator = UIActivityIndicatorView()

    // MARK: Setup
        
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        overrideUserInterfaceStyle = .dark
        loadData()
    }
    
    func config() {
        tableView.dataSource = self
        tableView.delegate = self
        activityIndicator()
        let selectedIndex = tabBarController!.selectedIndex
        switch selectedIndex {
        case 2:
            self.title = "Viewed"
        default:
            self.title = "Bookmarked"
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        self.view.addSubview(indicator)
    }
    
    func loadData() {
        indicator.startAnimating()
        mediaList.removeAll()
        let managedMediaList = DataManager.shared.fetchFilmHistory()!
        for managedMedia in managedMediaList {
            MediaService.getFilm(id: managedMedia.id) { (success, media) in
                if success, let media = media {
                    media.viewed = managedMedia.viewed
                    media.bookmark = managedMedia.bookmark
                    media.notes = managedMedia.notes
                    self.mediaList.append(media)
                } else {
                    self.presentNoDataAlert(title: "Oops...", message: "No Data")
                }
                DispatchQueue.main.async {
                    self.filterData()
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    func filterData() {
        // Function to filter list depending on which tab the user is on.
        let selectedIndex = tabBarController!.selectedIndex
        print("Index: \(selectedIndex)")
        switch selectedIndex {
        case 1:
            filteredList = mediaList.filter{ $0.bookmark == true }
        case 2:
            filteredList = mediaList.filter{ $0.viewed == true }
        default:
            filteredList = mediaList
        }
    }
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .cancel, handler: {(action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    // MARK: TableView Delegates and Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    // MARK: Cell Swipe Actions
    
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {(action, view, completion) in
            self.deleteItem(at: indexPath)
        }
        return UISwipeActionsConfiguration.init(actions: [delete])
    }
    
    func deleteItem(at indexPath: IndexPath) {
        // Deletes row in tableview
        tableView.beginUpdates()
        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        DataManager.shared.deleteFilm(for: cell.mediaId) // Deletes Film from CoreData
        mediaList.removeAll(where: {( $0.id == cell.mediaId)}) // Remove film from Array
        filteredList.removeAll(where: {( $0.id == cell.mediaId)}) // Remove film from Array
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFilmDetail" {
            let filmDetailViewController = segue.destination as! FilmDetailViewController
            let cell = sender as! ListTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            filmDetailViewController.filmID = filteredList[indexPath!.row].id
        }
    }
}
