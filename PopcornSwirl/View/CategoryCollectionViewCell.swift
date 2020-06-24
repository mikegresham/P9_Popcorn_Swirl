//
//  CategoryCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 24/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryCollectionViewCellDelegate{
    func showPicker()
}

class CategoryCollectionViewCell: UICollectionViewCell {
    var delegate: CategoryCollectionViewCellDelegate?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var selectedGenre = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        categoryLabel.isUserInteractionEnabled = true
        categoryLabel.addGestureRecognizer(tapGesture)
    }
    
    func setGenre(genre: String) {
        self.selectedGenre = genre
        self.categoryLabel.text = genre
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        delegate?.self.showPicker()

    }

}

