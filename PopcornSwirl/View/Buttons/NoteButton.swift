//
//  NoteButton.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 02/07/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class NoteButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        self.setImage(UIImage.init(systemName: "square.and.pencil"), for: .normal)
        self.setImage(UIImage.init(systemName: "square.and.pencil"), for: .selected)
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
