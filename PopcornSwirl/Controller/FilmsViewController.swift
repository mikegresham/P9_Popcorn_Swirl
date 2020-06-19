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
    
    var datasource: [MediaBrief] {
        return DataManager.shared.mediaList
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns: Int
        columns = (Int(filmsCollectionView.frame.size.width) - 20) / 152
        let width = (filmsCollectionView.frame.size.width - (20 * (CGFloat(columns) + 1))) / CGFloat(columns)
        let height = (width * 1.5) + 44
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "filmTile", for: indexPath) as! FilmCollectionViewCell
        let mediaBrief = datasource[indexPath.item]
        cell.populate(mediaBrief: mediaBrief)
        
        if let imageURL = URL(string: mediaBrief.artworkURL) {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmsCollectionView.dataSource = self
        filmsCollectionView.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .dark
    }
    
    func loadData() {
        MediaService.getMediaList(term: "Action") { (success, list) in
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
        }
    }

}
