//
//  ListTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 02/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class ListTableViewCell : UITableViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(media: Media) {
        self.titleLabel.text = media.title
        self.descriptionLabel.text = media.overview
        self.bookmarkButton.isSelected = media.bookmark == true ? true : false
        self.viewedButton.isSelected = media.viewed == true ? true : false
        self.notesButton.isSelected = media.notes != "" ? true : false
    }
    
    func setImage(image: UIImage){
        self.artworkImageView.image = image
    }
    
}
