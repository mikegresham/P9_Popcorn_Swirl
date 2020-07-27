//
//  TitleTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 27/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class SummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    @IBOutlet weak var viewedButton: ViewedButton!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func populate(media: Media) {
        titleLabel.text = media.title
        ratingLabel.text = media.ratingText + " " + media.scoreText
        bookmarkButton.isSelected = media.bookmark
        viewedButton.isSelected = media.viewed
        summaryLabel.text = "\(media.yearText) ∙ \(formatRuntime(runtime: media.runtime!))"
        descriptionLabel.text = media.overview
    }
    
    func formatRuntime(runtime: Int) -> String {
        let hours = runtime/60
        let minutes = runtime - (hours*60)
        
        let hoursplural = hours == 1 ? "" : "s"
        let minutesplural = minutes == 1 ? "" : "s"
        return "\(hours) hour\(hoursplural) \(minutes) minute\(minutesplural)"
    }
}
