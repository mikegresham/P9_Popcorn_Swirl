//
//  DescriptionTableViewCell.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 27/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class AdvertTableViewCell: UITableViewCell {
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.addSubview(bannerView)
    }
}
