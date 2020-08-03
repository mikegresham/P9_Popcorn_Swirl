//
//  FilmsViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 13/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    @IBOutlet weak var filmsCollectionViewFlowLayout: UICollectionViewFlowLayout!

    
    var selectedGenre: MediaGenre?
    
    var datasource: [MediaBrief] {
        return DataManager.shared.mediaList
    }
    
    var genres: [MediaGenre] {
        return  DataManager.shared.genreList
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    var selectedMedia: MediaBrief?
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:            
            let width = filmsCollectionView.frame.size.width - 40
            let height = CGFloat(41.0)
            return CGSize(width: width, height: height)
        default:
            var columns: Int
            columns = (Int(filmsCollectionView.frame.size.width) - 20) / 152
            let width = (filmsCollectionView.frame.size.width - (20 * (CGFloat(columns) + 1))) / CGFloat(columns)
            let height = (width * 1.5) + 44
            return CGSize(width: width, height: height)
        }

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        default:
            return datasource.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            cell.setGenre(genre: (selectedGenre?.name)!)
            cell.delegate = self
            return cell
        default:
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "filmTile", for: indexPath) as! FilmCollectionViewCell
            let mediaBrief = datasource[indexPath.item]
            cell.populate(mediaBrief: mediaBrief)
            cell.delegate = self
            if let imageURL = URL(string: mediaBrief.posterPath) {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmsCollectionView.dataSource = self
        filmsCollectionView.delegate = self
        filmsCollectionView.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        filmsCollectionView.refreshControl = refresher
        
        loadData()
        selectedGenre = genres.first
    }
    
    func backgroundImage(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background2")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @objc func refresh() {
        filmsCollectionView.refreshControl?.beginRefreshing()
        filmsCollectionView.reloadData()
        self.setGenre(genre: self.selectedGenre!)
        stopRefresher()
    }
    func stopRefresher() {
        self.filmsCollectionView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.async {
            self.filmsCollectionView.reloadData()
        }
    }
    
    func loadData() {
        MediaService.getLatestMediaList(query: "now_playing") { (success, list) in
            if success, let list = list {
                DataManager.shared.mediaList = list
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                //self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        }
        MediaService.getGenreList() { (success, list) in
            if success, var list = list {
                let latest = MediaGenre.init(id: 0, name: "Latest")
                list.insert(latest, at: 0)
                DataManager.shared.genreList = list
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                //self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        }
    }
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .cancel, handler: {(action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMediaDetail" {
            let filmDetailViewController = segue.destination as! FilmDetailViewController
            let indexPath = filmsCollectionView.indexPath(for: sender as!  UICollectionViewCell)
            filmDetailViewController.mediaID = DataManager.shared.mediaList[indexPath!.item].id
        } else if segue.identifier == "addNoteSegue" {
            let addNoteViewController = segue.destination as! AddNoteViewController
            addNoteViewController.mediaBrief = self.selectedMedia!
        }
    }
    
    func setGenre(genre: MediaGenre){
        self.selectedGenre = genre
        
        switch genre.id {
        case 0:
            MediaService.getLatestMediaList(query: "now_playing") { (success, list) in
                if success, let list = list {
                    DataManager.shared.mediaList = list
                    
                    DispatchQueue.main.async {
                        self.filmsCollectionView.reloadData()
                    }
                } else {
                    //self.presentNoDataAlert(title: "Oops...", message: "No Data")
                }
                
            }
        default:
        MediaService.getGenreMediaList(id: genre.id!) { (success, list) in
            if success, let list = list {
                DataManager.shared.mediaList = list
                
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                //self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        }
        }
    }
}

extension FilmsViewController: CategoryCollectionViewCellDelegate {
    func updateGenre(genre: MediaGenre) {
        setGenre(genre: genre)
    }
}

extension FilmsViewController: FilmCollectionViewCellDelegate {
    func addNote(mediaBrief: MediaBrief) {
        self.selectedMedia = mediaBrief
    }
}
