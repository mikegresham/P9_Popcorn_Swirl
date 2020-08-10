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
        context = appDelegate.persistentContainer.newBackgroundContext()
        entity = NSEntityDescription.entity(forEntityName: "ManagedFilm", in: context)
    }
    
    // MARK: Create
    lazy var filmList: [FilmBrief] = {
        var list = [FilmBrief]()
        
        for i in 0 ..< 20 {
            var film = FilmBrief(id: 00000000, title: "Movie", posterPath: "https://critics.io/img/movies/poster-placeholder.png", notes: nil, bookmark: false, viewed: false)
            list.append(film)
        }
        return list
    } ()
    
    lazy var genreList: [FilmGenre] = {
        var list = [FilmGenre]()
        
        var genre = FilmGenre.init(id: 0, name: "Latest")
        list.append(genre)
        return list
    } ()
    
    func createFilm(id: Int, bookmark: Bool, viewed: Bool, notes: String?) {
        let newFilm = NSEntityDescription.insertNewObject(forEntityName: ManagedFilm.entityName, into: context) as! ManagedFilm
        newFilm.id = id
        newFilm.bookmark = bookmark
        newFilm.viewed = viewed
        if notes != nil {
            newFilm.notes = notes!
        } else {
            newFilm.notes = ""
        }
    saveContext()
    }
    
    // MARK: Read
    
    func fetchFilm(id: Int) -> ManagedFilm? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedFilm.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(ManagedFilm.id), id as CVarArg)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [ManagedFilm]
            return result.first
        } catch { print("Fetch on film id: \(id) failed. \(error)")}
        return nil
    }
    
    func fetchFilmHistory() -> [ManagedFilm]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ManagedFilm.entityName)
        
        let sectionSortDescriptor = NSSortDescriptor(key: "lastModified", ascending: true)
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest) as! [ManagedFilm]
            return result
        }
        catch {
            
        }
        return nil
    }
    
    // MARK: Update
    
    func updateFilm(film: FilmBrief) {
        if film.viewed != false || film.bookmark != false || film.notes != "" {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedFilm.entityName)
            request.predicate = NSPredicate(format: "%K == %i", #keyPath(ManagedFilm.id), film.id as CVarArg)
             do {
                 let result = try context.fetch(request)
                 if let returnedResult = result as? [ManagedFilm] {
                     if returnedResult.count != 0 {
                         let managedFilm = returnedResult.first!
                        managedFilm.viewed = film.viewed
                        managedFilm.bookmark = film.bookmark
                        if film.notes != nil{
                            managedFilm.notes = film.notes!
                        } else {
                            managedFilm.notes = ""
                        }
                        managedFilm.lastModified = Date.init()
                         saveContext()
                     } else {
                        print("Fetch result was empty for specified film id: \(film.id)")
                        
                        self.createFilm(id: film.id, bookmark: film.bookmark, viewed: film.viewed, notes: film.notes)
                        print("Created new film: \(film.id)")
                    }
                 }
            } catch {
                }
        } else {
            deleteFilm(for: film.id)
        }
        
    }
    
    
    // MARK: Delete
    
    func deleteFilm(for id: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ManagedFilm.entityName)
        request.predicate = NSPredicate(format: "%K == %i", #keyPath(ManagedFilm.id), id as CVarArg)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request) as! [ManagedFilm]
            context.delete(result.first!)
        } catch {
            print("Failed to delted film with id:\(id)")
        }
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            print("Save failed: \(error)")
            context.rollback()
        }
    }
}

