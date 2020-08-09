//
//  FilmCollectionViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

protocol FilmCollectionViewCellDelegate{
    func addNote(mediaBrief: MediaBrief)
}

class FilmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var artworkImageView: UIImageView!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var notesButton: UIButton!
    @IBOutlet weak var viewedButton: ViewedButton!
    
    var delegate: FilmCollectionViewCellDelegate?
    var mediaBrief: MediaBrief?
    
    @IBAction func bookmarkButtonPressed(_ sender: Any) {
        bookmarkButton.isSelected.toggle()
        mediaBrief!.bookmark = bookmarkButton.isSelected
        DataManager.shared.updateMedia(media: mediaBrief!)
        DataManager.shared.mediaList.first(where: {$0.id == mediaBrief?.id})?.bookmark = bookmarkButton.isSelected
    }
    @IBAction func viewedButtonPressed(_ sender: Any) {
        viewedButton.isSelected.toggle()
        mediaBrief!.viewed =  viewedButton.isSelected
        DataManager.shared.updateMedia(media: mediaBrief!)
        DataManager.shared.mediaList.first(where: {$0.id == mediaBrief?.id})?.viewed = viewedButton.isSelected
    }
    @IBAction func notesButtonPressed(_ sender: Any) {
        delegate?.addNote(mediaBrief: mediaBrief!)
    }
    override func awakeFromNib() {
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 0.2
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.masksToBounds = true
        self.backgroundColor = .clear
    }
    
    func populate(mediaBrief: MediaBrief) {
        self.mediaBrief = mediaBrief
        bookmarkButton.isSelected = mediaBrief.bookmark
        viewedButton.isSelected = mediaBrief.viewed
        if mediaBrief.notes != nil {
            notesButton.isSelected = mediaBrief.notes != "" ? true : false
        } else {
            notesButton.isSelected = false
        }
    }
    
    func setImage(image: UIImage) {
        artworkImageView.image = image
    }
    
}

