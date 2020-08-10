//
//  ImageTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 27/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    func populate(imageURL: String) {
        if let imageURL = URL(string: imageURL) {
                MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                    if success, let imageData = imageData,
                        let artwork = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.backdropImageView.image = artwork
                        }
                    }
                })
            }
        }
}

