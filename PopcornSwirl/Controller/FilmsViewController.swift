//
//  FilmsViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 13/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = filmsCollectionView.dequeueReusableCell(withReuseIdentifier: "filmTile", for: indexPath)
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filmsCollectionView.dataSource = self
        filmsCollectionView.delegate = self
    }
}
