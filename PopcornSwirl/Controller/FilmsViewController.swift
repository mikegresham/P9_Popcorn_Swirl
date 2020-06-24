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
    @IBOutlet weak var genrePickerView: UIPickerView!
    @IBOutlet weak var pickerToolBar: UIToolbar!
    
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
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
        genrePickerView.delegate = self
        genrePickerView.dataSource = self
        toggleGenrePicker(hidden: true)
        setGenrePickerView()
        loadData()
        selectedGenre = genres.first
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.isHidden = true
    }
    
    func loadData() {
        MediaService.getLatestMediaList(query: "popular") { (success, list) in
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
        }
    }
    func setGenre(genre: MediaGenre){
        self.selectedGenre = genre
        filmsCollectionView.reloadData()
    }
    func toggleGenrePicker(hidden: Bool) {
        genrePickerView.isHidden = hidden
        pickerToolBar.isHidden = hidden
    }

}


extension FilmsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.shared.genreList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataManager.shared.genreList[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setGenre(genre: DataManager.shared.genreList[row])
        toggleGenrePicker(hidden: true)
    }
    func setGenrePickerView(){
        genrePickerView.backgroundColor = UIColor.black
        
    }
    
}

extension FilmsViewController: CategoryCollectionViewCellDelegate {
    func showPicker() {
        toggleGenrePicker(hidden: false)
    }
}
