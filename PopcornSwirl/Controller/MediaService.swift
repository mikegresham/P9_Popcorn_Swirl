//
//  MediaService.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//
import Foundation



class MediaService {
    
    private static let responseMessages = [
        200: "Success.",
        201: "The item/record was updated successfully.",
        400: "Validation failed.",
        401: "Authentication failed: You do not have permissions to access the service.",
        403: "Duplicate entry: The data you tried to submit already exists.",
        404: "Invalid id: The pre-requisite id is invalid or not found.",
        405: "Invalid format: This service doesn't exist in that format.",
        406: "Invalid accept header.",
        422: "Invalid parameters: Your request parameters are incorrect.",
        429: "Your request count (#) is over the allowed limit of (40).",
        500: "Internal error: Something went wrong, contact TMDb.",
        501: "Invalid service: this service does not exist.",
        503: "Service offline: This service is temporarily offline, try again later.",
        504: "Your request to the backend server timed out. Try again."
    ]
    
    private struct API {
        private static let base = "https://api.themoviedb.org/3/"
        private static let search = API.base + "search/movie"
        private static let lookup = API.base + "movie/"
        private static let genreList = API.base + "genre/movie/list"
        private static let genre = API.base + "discover/movie"
        
        
        static let apiKey = "4055e5179f75e73acdb4f6b3b1a8e472"
        static let searchURL = API.search
        static let lookupURL = API.lookup
        static let genreListURL = API.genreList
        static let genreURL = API.genre
    }
    
    
    private static func createRequest(url: URL, params: [String: Any]) -> URLRequest{
    
        let body = params.map{ "\($0)=\($1)" }.joined(separator: "&")
        var request = URLRequest(url: URL(string: "\(url)?\(body)")!)
        request.httpMethod = "GET"
        return request
    }
    
    private static func createSearchRequest(query: String) -> URLRequest{
        let params = ["api_key": API.apiKey, "query": query, "language": "en-UK", "include_adult": "false", "region": "UK"]
        return createRequest(url: URL(string: API.searchURL)!, params: params)
    }
    
    private static func createLookupRequest(id: Int) -> URLRequest{
        let params = ["api_key": API.apiKey, "append_to_response": "recommendations"]
        return createRequest(url: URL(string: API.lookupURL + "\(id)")! , params: params)
    }
    private static func createLatestRequest(query: String) -> URLRequest{
        let params = ["api_key": API.apiKey]
      return createRequest(url: URL(string: API.lookupURL + "\(query)")! , params: params)
    }
    private static func createGenreListRequest() -> URLRequest{
        let params = ["api_key": API.apiKey]
      return createRequest(url: URL(string: API.genreListURL)! , params: params)
    }
    private static func createGenreRequest(genre: Int) -> URLRequest{
        let params = ["api_key": API.apiKey, "with_genres": genre, "language": "en-UK", "include_adult": "false", "sort_by": "popularity.desc", "page": "1"] as [String : Any]
      return createRequest(url: URL(string: API.genreURL)! , params: params)
    }
    
    static func getGenreList(completion: @escaping (Bool, [MediaGenre]?) -> Void){
        let session = URLSession(configuration: .default)
        let request = createGenreListRequest()
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let results = responseJSON["genres"] as? [AnyObject] {
                        //Process the results

                        var list = [MediaGenre]()
                    for i in 0 ..< results.count {
                        guard let genre = results[i] as? [String: Any] else {
                            continue
                        }
                        if let id = genre["id"] as? Int,
                            let name = genre["name"] as? String {
                            let mediaGenre = MediaGenre(id: id, name: name)
                            
                            list.append(mediaGenre)
                        }
                        
                    }
                    completion(true, list)
                } else if let response = response as? HTTPURLResponse {
                    print(responseMessages[response.statusCode]!)
                    completion(false, nil)
                }
            } else {
                completion(false, nil)
            }
        }
        task.resume()
        
    }
    
    static func getMediaList(query: String, completion: @escaping (Bool, [MediaBrief]?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createSearchRequest(query: query)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                        //Process the results

                        var list = [MediaBrief]()
                    for i in 0 ..< results.count {
                        guard let film = results[i] as? [String: Any] else {
                            continue
                        }
                        if let id = film["id"] as? Int,
                            let title = film["title"] as? String,
                            let posterPath = film["poster_path"] as? String {
                            let mediaBrief = MediaBrief(id: id, title: title, posterPath: "https://image.tmdb.org/t/p/w500\(posterPath)", notes: nil, bookmark: false, viewed: false)
                            
                            list.append(mediaBrief)
                        }
                        
                    }

                    completion(true, list)
                } else if let response = response as? HTTPURLResponse {
                    print(responseMessages[response.statusCode]!)
                    completion(false, nil)
                }
                
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    static func getMedia(id: Int, completion: @escaping (Bool, Media?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createLookupRequest(id: id)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {


                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        //Process the results
                    let film = responseJSON
                    
                    
                    let recommendations = film["recommendations"] as! [String : Any]
                    let results =  recommendations["results"] as? [AnyObject]
                    var list = [MediaBrief]()
                    
                    for i in 0 ..< results!.count {
                        guard let film = results![i] as? [String: Any] else {
                            continue
                        }
                        if let id = film["id"] as? Int, let title = film["title"] as? String,
                            let posterPath = film["poster_path"] as? String {
                            let mediaBrief = MediaBrief(id: id, title: title, posterPath: "https://image.tmdb.org/t/p/w500\(posterPath)", notes: nil, bookmark: false, viewed: false)
                            if let managedMedia = DataManager.shared.fetchMedia(id: id) {
                                mediaBrief.notes = managedMedia.notes
                                mediaBrief.viewed = managedMedia.viewed
                                mediaBrief.bookmark = managedMedia.bookmark
                                print(mediaBrief.viewed)
                            }
                            
                            list.append(mediaBrief)
                        }
                    }
                    print(list.count)

                    if  let id = film["id"] as? Int,
                        let title = film["title"] as? String,
                        let posterPath = film["poster_path"] as? String,
                        let backdropPath = film["backdrop_path"] as? String,
                        let overview = film["overview"] as? String,
                        let voteAverage = film["vote_average"] as? Double,
                        let voteCount = film["vote_count"] as? Int,
                        let runtime = film["runtime"] as? Int, let releaseDate = film["release_date"] as? String {
                        let media = Media(id: id, title: title, posterPath: "https://image.tmdb.org/t/p/w500\(posterPath)", backdropPath: "https://image.tmdb.org/t/p/w500\(backdropPath)", overview: overview, voteAverage: voteAverage, voteCount: voteCount, runtime: runtime, releaseDate: releaseDate, notes: nil, bookmark: false, viewed: false, recommendations: list)
                        completion(true, media)
                    } else {
                        completion(false, nil)
                    }
                } else if let response = response as? HTTPURLResponse {
                    print(responseMessages[response.statusCode]!)
                    completion(false, nil)
                }
                
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    static func getImage(imageURL: URL, completion: @escaping (Bool, Data?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: imageURL) { (data, response, error) in
            if let data = data, error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                completion(true, data)
            } else if let response = response as? HTTPURLResponse {
                print(responseMessages[response.statusCode]!)
                completion(false, nil)
               
            }
        }
        task.resume()
    }
    
    static func getLatestMediaList(query: String, completion: @escaping (Bool, [MediaBrief]?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createLatestRequest(query: query)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                        //Process the results

                        var list = [MediaBrief]()
                    for i in 0 ..< results.count {
                        guard let film = results[i] as? [String: Any] else {
                            continue
                        }
                        if let id = film["id"] as? Int, let title = film["title"] as? String,
                            let posterPath = film["poster_path"] as? String {
                            let mediaBrief = MediaBrief(id: id, title: title, posterPath: "https://image.tmdb.org/t/p/w500\(posterPath)", notes: nil, bookmark: false, viewed: false)
                            if let managedMedia = DataManager.shared.fetchMedia(id: id) {
                                mediaBrief.notes = managedMedia.notes
                                mediaBrief.viewed = managedMedia.viewed
                                mediaBrief.bookmark = managedMedia.bookmark
                                print(mediaBrief.viewed)
                            }
                            
                            list.append(mediaBrief)
                        }
                        
                    }
                    completion(true, list)
                } else if let response = response as? HTTPURLResponse {
                    print(responseMessages[response.statusCode]!)
                    completion(false, nil)
                }
                
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    static func getGenreMediaList(id: Int, completion: @escaping (Bool, [MediaBrief]?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createGenreRequest(genre: id)

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data, error == nil {
                if let response = response as? HTTPURLResponse, response.statusCode == 200,
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                        //Process the results

                        var list = [MediaBrief]()
                    for i in 0 ..< results.count {
                        guard let film = results[i] as? [String: Any] else {
                            continue
                        }
                        if let id = film["id"] as? Int, let title = film["title"] as? String,
                            let posterPath = film["poster_path"] as? String {
                            let mediaBrief = MediaBrief(id: id, title: title, posterPath: "https://image.tmdb.org/t/p/w500\(posterPath)", notes: nil, bookmark: false, viewed: false)
                            list.append(mediaBrief)
                        }
                        
                    }
                    
                    completion(true, list)
                } else if let response = response as? HTTPURLResponse {
                    print(responseMessages[response.statusCode]!)
                    completion(false, nil)
                }
                
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
    
}
