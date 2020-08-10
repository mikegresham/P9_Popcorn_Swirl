//
//  RatingsTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 27/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    var film: FilmBrief?
    
    func populate(film: FilmBrief) {
        self.film = film
        if let imageURL = URL(string: film.posterPath) {
            MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.posterImageView.image = artwork
                    }
                }
                
            })
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 0.2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = true
        self.backgroundColor = .clear
    }
    
    
}
