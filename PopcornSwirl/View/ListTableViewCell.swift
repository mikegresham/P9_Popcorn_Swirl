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
    
    // MARK: IBOutlets
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    
    //MARK: Global Variables
    
    var mediaId = Int()
    
    //MARK: Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populate(media: Film) {
        self.titleLabel.text = media.title
        self.descriptionLabel.text = media.overview
        self.bookmarkButton.isSelected = media.bookmark == true ? true : false
        self.viewedButton.isSelected = media.viewed == true ? true : false
        self.notesButton.isSelected = media.notes != "" ? true : false
        self.mediaId = media.id
    }
    
    func setImage(image: UIImage){
        self.artworkImageView.image = image
    }
}
