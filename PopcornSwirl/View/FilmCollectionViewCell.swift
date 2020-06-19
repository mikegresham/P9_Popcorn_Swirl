//
//  FilmCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    func populate(mediaBrief: MediaBrief) {
        bookmarkButton.isSelected = mediaBrief.bookmark
        viewedButton.isSelected = mediaBrief.viewed
        if mediaBrief.notes != nil {
            self.notesButton.isSelected = true
        }
    }
    
    func setImage(image: UIImage) {
        artworkImageView.image = image
    }
}
