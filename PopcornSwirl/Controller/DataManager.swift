//
//  DataManager.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {
        
    }
    
    lazy var mediaList: [MediaBrief] = {
        var list = [MediaBrief]()
        
        for i in 0 ..< 40 {
            var media = MediaBrief(id: 00000000, artworkURL: "https://critics.io/img/movies/poster-placeholder.png", notes: nil, bookmark: false, viewed: false)
            list.append(media)
        }
        return list
    } ()
}

