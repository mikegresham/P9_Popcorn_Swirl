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
    
    var media: Film?
    
    @IBAction func bookmarkButtonAction(_ sender: Any) {
        bookmarkButton.isSelected.toggle()
        self.media?.bookmark = bookmarkButton.isSelected
        DataManager.shared.updateFilm(film: media!)
            DataManager.shared.filmList.first(where: {$0.id == media?.id})?.bookmark = bookmarkButton.isSelected
    }
    
    @IBAction func viewedButtonAction(_ sender: Any) {
        viewedButton.isSelected.toggle()
               media!.viewed =  viewedButton.isSelected
               DataManager.shared.updateFilm(film: media!)
               DataManager.shared.filmList.first(where: {$0.id == media?.id})?.viewed = viewedButton.isSelected
    }
    
    func populate(film: Film) {
        self.media = film
        titleLabel.text = film.title
        ratingLabel.text = film.ratingText + " " + film.scoreText
        bookmarkButton.isSelected = film.bookmark
        viewedButton.isSelected = film.viewed
        summaryLabel.text = "\(film.yearText) ∙ \(formatRuntime(runtime: film.runtime!))"
        descriptionLabel.text = film.overview
    }
    
    func formatRuntime(runtime: Int) -> String {
        let hours = runtime/60
        let minutes = runtime - (hours*60)
        
        let hoursplural = hours == 1 ? "" : "s"
        let minutesplural = minutes == 1 ? "" : "s"
        return "\(hours) hour\(hoursplural) \(minutes) minute\(minutesplural)"
    }
}
