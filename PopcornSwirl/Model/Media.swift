//
//  Media.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation

class MediaBrief {
    //Attributes
    var id: Int
    var artworkURL: String
    var notes: String?
    var bookmark: Bool
    var viewed: Bool
    
    var artworkData: Data?
    
    init(id: Int, artworkURL: String, notes: String?, bookmark: Bool, viewed: Bool) {
        self.id = id
        self.artworkURL = artworkURL
        self.bookmark = bookmark
        self.viewed = viewed
        if let notes = notes {
            self.notes = notes
        }
        
    }
}

class Media: MediaBrief {
    var title: String
    var genre: String
    var description: String

    
    init(id: Int, title: String, artworkURL: String, genre: String, description: String, notes: String?, bookmark: Bool, viewed: Bool){
        
        self.genre = genre
        self.description = description
        self.title = title
        super.init(id: id, artworkURL: artworkURL, notes: notes, bookmark: bookmark, viewed: viewed)
    }
}
