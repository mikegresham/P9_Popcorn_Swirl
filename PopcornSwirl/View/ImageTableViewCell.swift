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
    
    func setup(imageURL: String) {
        if let imageURL = URL(string: imageURL) {
                MediaService.getImage(imageURL: imageURL, completion: { (success, imageData) in
                    if success, let imageData = imageData,
                        let artwork = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.backdropImageView.image = artwork
                            self.setGradientLayer()
                        }
                    }
                    
                })
            }
        }
    
    func setGradientLayer() {
        let width = backdropImageView.frame.width
        let height = backdropImageView.frame.height
        let sHeight:CGFloat = 100
        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        backdropImageView.layer.insertSublayer(bottomImageGradient, at: 0)
    }
}

