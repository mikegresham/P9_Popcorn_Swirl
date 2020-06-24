//
//  DataManager.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 18/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    var context: NSManagedObjectContext
    var entity: NSEntityDescription?
    
    static let shared = DataManager()
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: ManagedMedia.entityName, in: context)
    }
    
    // Create
    lazy var mediaList: [MediaBrief] = {
        var list = [MediaBrief]()
        
        for i in 0 ..< 40 {
            var media = MediaBrief(id: 00000000, posterPath: "https://critics.io/img/movies/poster-placeholder.png", notes: nil, bookmark: false, viewed: false)
            list.append(media)
        }
        return list
    } ()
    
    lazy var genreList: [MediaGenre] = {
        var list = [MediaGenre]()
        
        var genre = MediaGenre.init(id: 0, name: "Latest")
        list.append(genre)
        return list
    } ()
    
    private func createMedia(id: Int, bookmark: Bool, viewed: Bool, notes: String?) {
        let newMedia = NSEntityDescription.insertNewObject(forEntityName: ManagedMedia.entityName, into: context) as! ManagedMedia
        newMedia.id = id
        newMedia.bookmark = bookmark
        newMedia.viewed = viewed
        if notes != nil {
            newMedia.notes = notes!
        }
    saveContext()
    }
    
    // Read
    
    func fetchMedia(id: Int) -> ManagedMedia?{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ManagedMedia.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(ManagedMedia.id), id as CVarArg)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [ManagedMedia]
            return result.first
        } catch { print("Fetch on media id: \(id) failed. \(error)")}
        return nil
    }
    
    func fetchMediaHistory() -> [ManagedMedia]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ManagedMedia.entityName)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "lastModified", ascending: true)
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [ManagedMedia]
            return result
        }
        catch {
            
        }
        return nil
    }
    
    // Update
    
    // Delete
    
    
    
    private func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Save failed: \(error)")
            context.rollback()
        }
    }
}

