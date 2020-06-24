//
//  ViewedButton.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 24/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit

class ViewedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
        self.setImage(UIImage.init(systemName: "eye"), for: .normal)
        self.setImage(UIImage.init(systemName: "eye.fill"), for: .selected)
    }
    
}
