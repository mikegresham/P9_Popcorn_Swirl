//
//  RecommendedTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 09/08/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class RecommendedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var recommendations: [MediaBrief]?
    
    @IBOutlet weak var recommendedCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = recommendations?.count {
            return items
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recommendedCollectionView.dequeueReusableCell(withReuseIdentifier: "recommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
        cell.populate(media: recommendations![indexPath.row])
        return cell
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recommendedCollectionView.delegate = self
        recommendedCollectionView.dataSource = self
        
    }
    
    func populate(recommendations: [MediaBrief]) {
        self.recommendations = recommendations
        recommendedCollectionView.reloadData()
    }
}
