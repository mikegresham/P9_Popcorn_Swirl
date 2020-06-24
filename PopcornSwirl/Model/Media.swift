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
    var posterPath: String
    var notes: String?
    var bookmark: Bool
    var viewed: Bool
    
    var artworkData: Data?
    
    init(id: Int, posterPath: String, notes: String?, bookmark: Bool, viewed: Bool) {
        self.id = id
        self.posterPath = posterPath
        self.bookmark = bookmark
        self.viewed = viewed
        if let notes = notes {
            self.notes = notes
        }
        
    }
}

class Media: MediaBrief {
    var title: String
    var backdropPath: String?
    var overview: String
    var voteAverage: Double
    var voteCount: Int
    var runtime: Int?
    var releaseDate: String?
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0..<rating).reduce("") { (acc, _) -> String in
            return acc + "★"
        }
        return ratingText
    }
    
    var scoreText: String {
        guard ratingText.count > 0 else {
            return "n/a"
        }
        return "\(ratingText.count)/10"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = dateFormatter.date(from: releaseDate) else { return "n/a" }
        return yearFormatter.string(from: date)
    }
    
    init(id: Int, title: String, posterPath: String, backdropPath: String?, overview: String, voteAverage: Double, voteCount: Int, runtime: Int?, releaseDate: String?, notes: String?, bookmark: Bool, viewed: Bool){
        
        self.backdropPath = backdropPath
        self.overview = overview
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.runtime = runtime
        self.releaseDate = releaseDate
        
        super.init(id: id, posterPath: posterPath, notes: notes, bookmark: bookmark, viewed: viewed)
    }
    
    let yearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }()
     
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}

class MediaGenre {
    var id: Int?
    var name: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
