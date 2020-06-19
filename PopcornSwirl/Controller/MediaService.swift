//
//  MediaService.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//
import Foundation

class MediaService {
    private struct API {
        private static let base = "https://itunes.apple.com/"
        private static let search = API.base + "search"
        private static let lookup = API.base + "lookup"
        
        static let searchURL = URL(string: API.search)!
        static let lookupURL = URL(string: API.lookup)!
    }
    
    private static func createRequest(url: URL, params: [String: Any]) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = params.map{ "\($0)=\($1)" }.joined(separator: "&")
        request.httpBody = body.data(using: .utf8)
        
        return request
    }
    
    private static func createSearchRequest(term: String) -> URLRequest{
        let params = ["term": term, "media": "movie", "entity": "movie"]
        return createRequest(url: API.searchURL, params: params)
    }
    
    private static func createLookupRequest(id: Int) -> URLRequest{
          let params = ["id": id]
          return createRequest(url: API.lookupURL, params: params)
      }
      
    
    static func getMediaList(term: String, completion: @escaping (Bool, [MediaBrief]?) -> Void) {
        let session = URLSession(configuration: .default)
        let request = createSearchRequest(term: term)
        
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
                        if let id = film["trackId"] as? Int,
                            let artworkURL = film["artworkUrl100"] as? String {
                            let mediaBrief = MediaBrief(id: id, artworkURL: artworkURL, notes: nil, bookmark: false, viewed: false)
                            
                            list.append(mediaBrief)
                        }
                        
                    }
                    completion(true, list)
                } else {
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
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                    let results = responseJSON["results"] as? [AnyObject] {
                        //Process the results
                    if results.count > 0,
                        let film = results[0] as? [String: Any],
                        let id = film["trackId"] as? Int,
                        let title = film["trackName"] as? String,
                        let artworkURL = film["artworkUrl100"] as? String,
                        let description = film["longDescription"] as? String,
                        let genre = film["primaryGenreName"] as? String {
                        let media = Media(id: id, title: title, artworkURL: artworkURL, genre: genre, description: description, notes: nil, bookmark: false, viewed: false)

                        completion(true, media)
                    } else {
                        completion(false, nil)
                    }
                } else {
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
                let response = response as? HTTPURLResponse, response.statusCode == 200{
                completion(true, data)
            } else {
                completion(false, nil)
            }
        }
        task.resume()
    }
}
