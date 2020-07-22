//
//  BookmarkButton.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 24/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class BookmarkButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        self.setImage(UIImage.init(systemName: "bookmark"), for: .normal)
        self.setImage(UIImage.init(systemName: "bookmark.fill"), for: .selected)
    }
    override var isSelected: Bool{
            didSet{
                if self.isSelected {
                    self.tintColor = UIColor.orange
                }
                else{
                    self.tintColor = UIColor.white
                }
            }
        }
    
}
