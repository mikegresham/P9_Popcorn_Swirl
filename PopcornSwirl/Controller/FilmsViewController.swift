//
//  FilmsViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 13/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    @IBOutlet weak var filmsCollectionViewFlowLayout: UICollectionViewFlowLayout!

    // MARK: Global Variables
    
    var selectedMedia: FilmBrief?
    var selectedGenre: FilmGenre?
    var datasource: [FilmBrief] { return DataManager.shared.filmList }
    var genres: [FilmGenre] { return  DataManager.shared.genreList }
    var page = Int()

    // MARK: Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        // Reload films data
        DispatchQueue.main.async {
            self.filmsCollectionView.reloadData()
        }
    }
    
    func config() {
        //Custom UI
        displayBackgroundImage()
        overrideUserInterfaceStyle = .dark

        //Delegates & Datasoucre
        filmsCollectionView.dataSource = self
        filmsCollectionView.delegate = self
        filmsCollectionView.alwaysBounceVertical = true
        
        //Refresh Control
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        filmsCollectionView.refreshControl = refresher
        
        //Load films for collectionView
        loadGenreList()
        page = 1
        selectedGenre = genres.first
        setGenre(genre: selectedGenre!)
    }
    
    func displayBackgroundImage(){
        //Display background image, and add blur.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode = .scaleAspectFill
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    @objc func refresh() {
        //Refresh control on collectionview
        filmsCollectionView.refreshControl?.beginRefreshing()
        page = 1
        self.setGenre(genre: self.selectedGenre!)
        stopRefresher()
    }
    
    func stopRefresher() {
        // Stop refreshing collectionview
        self.filmsCollectionView.refreshControl?.endRefreshing()
    }
    
    func loadGenreList() {
        MediaService.getGenreList() { (success, list) in
            if success, var list = list {
                let latest = FilmGenre.init(id: 0, name: "Latest")
                list.insert(latest, at: 0)
                DataManager.shared.genreList = list
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
        }
    }
    
    func loadData() {
        MediaService.getLatestMediaList(query: "now_playing", page: page) { (success, list) in
            if success, let list = list {
                DataManager.shared.filmList = list
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
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
            filmDetailViewController.filmID = DataManager.shared.filmList[indexPath!.item].id
        } else if segue.identifier == "addNoteSegue" {
            let addNoteViewController = segue.destination as! AddNoteViewController
            addNoteViewController.filmBrief = self.selectedMedia!
        }
    }
    
    func setGenre(genre: FilmGenre){
        if genre.id != selectedGenre!.id {
            self.selectedGenre = genre
            page = 1
        }
        
        switch genre.id {
        case 0:
            MediaService.getLatestMediaList(query: "now_playing", page: page) { (success, list) in
                if success, let list = list {
                    if self.page == 1 {
                        DataManager.shared.filmList.removeAll()
                        DataManager.shared.filmList = list
                    } else {
                        DataManager.shared.filmList.append(contentsOf: list)
                    }
                    DispatchQueue.main.async {
                        self.filmsCollectionView.reloadData()
                    }
                } else {
                    self.presentNoDataAlert(title: "Oops...", message: "No Data")
                }
                
            }
        default:
            MediaService.getGenreMediaList(id: genre.id!, page: page) { (success, list) in
            if success, let list = list {
                if self.page == 1 {
                    DataManager.shared.filmList.removeAll()
                    DataManager.shared.filmList = list
                } else {
                    DataManager.shared.filmList.append(contentsOf: list)
                }
                DispatchQueue.main.async {
                    self.filmsCollectionView.reloadData()
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        }
        }
    }
}

extension FilmsViewController: GenreCollectionViewCellDelegate {
    func updateGenre(genre: FilmGenre) {
        setGenre(genre: genre)
    }
}

extension FilmsViewController: FilmCollectionViewCellDelegate {
    func addNote(mediaBrief: FilmBrief) {
        self.selectedMedia = mediaBrief
    }
}

extension FilmsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: CollectionView Functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Header and films section
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Custom size cell, based on size of screen
        switch indexPath.section {
        case 0:
            // Header section, width of screen
            let width = filmsCollectionView.frame.size.width - 40
            let height = CGFloat(41.0)
            return CGSize(width: width, height: height)
        default:
            // Minimum film cell size is 132 + 20 spacing. Adaptive layout based on screen size.
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
            // Header cell
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as! GenreCollectionViewCell
            cell.setGenre(genre: (selectedGenre?.name)!)
            cell.delegate = self
            return cell
        default:
            // Film Cells
            let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "filmTile", for: indexPath) as! FilmCollectionViewCell
            let filmBried = datasource[indexPath.item]
            cell.populate(mediaBrief: filmBried)
            cell.delegate = self
            if let imageURL = URL(string: filmBried.posterPath) {
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
        //No header
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //No Footer
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == DataManager.shared.filmList.count - 1 {
            page += 1
            setGenre(genre: selectedGenre!)
        }
    }
}
