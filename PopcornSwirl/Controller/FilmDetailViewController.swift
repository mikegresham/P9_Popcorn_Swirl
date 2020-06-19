//
//  FilmDetailViewController.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class FilmDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artworkImageView.image = UIImage.init(named: "placeholder")
        overrideUserInterfaceStyle = .dark
        MediaService.getMedia(id: mediaID, completion: { (success, media) in
            if success, let media = media {
                self.media = media
                
                DispatchQueue.main.async {
                    self.populate(media: media)
                }
            } else {
                self.presentNoDataAlert(title: "Oops...", message: "No Data")
            }
            
        })
 

    }
    
    var mediaID: Int!
    
    private var media: Media?
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var viewedButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func populate(media: Media){
        self.title = media.title
        self.descriptionLabel.text = media.description
        self.bookmarkButton.isSelected = media.bookmark
        self.viewedButton.isSelected = media.viewed
        
        if let imageURL = URL(string: media.artworkURL) {
            MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                if success, let imageData = imageData,
                    let artwork = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self.artworkImageView.image = artwork
                    }
                }
                
            })
        }
    }
    
    
    func presentNoDataAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Got it!", style: .cancel, handler: {(action) -> Void in
        })
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
