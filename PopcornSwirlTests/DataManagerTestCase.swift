//
//  DataManagerTestCase.swift
//  PopcornSwirlTests
//
//  Created by Michael Gresham on 14/08/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import XCTest
import CoreData
@testable import Popcorn_Swirl

class DataManagerTestCase: XCTestCase {
    
    var dataManager: DataManager!
    var mediaService: MediaService!
    var managedContext: NSManagedObjectContext!

    
    override func setUp() {
        super.setUp()
    }

    func testGivenFilmDoesNotExist_WhenFilmIsUpdated_ThenFilmIsCreated() {
        //Setup
        let id = 550 //RandomFilm ID
        DataManager.shared.deleteFilm(for: id) //Ensure Film is not already stored
        
        
        //Test
        let filmsBeforeTest = DataManager.shared.fetchFilmHistory()!.count
        
        let filmBrief = FilmBrief(id: 550, title: "Film", posterPath: "url", notes: nil, bookmark: true, viewed: true) // Create Film
        DataManager.shared.updateFilm(film: filmBrief) //Update film should save film, if not already stored
        
        let filmsAfterTest = DataManager.shared.fetchFilmHistory()!.count
        
        //Result
        XCTAssert(filmsAfterTest == filmsBeforeTest + 1)
        
        
        //Clean Up
        DataManager.shared.deleteFilm(for: id)
    }
    
    func testGivenFilmIsStored_WhenFilmIsUpdated_ChangesAreSaved() {
        //Setup
        let id = 550 //RandomFilm ID
        DataManager.shared.deleteFilm(for: id) //Ensure Film is not already stored
        let filmBrief1 = FilmBrief(id: 550, title: "Film", posterPath: "url", notes: nil, bookmark: true, viewed: true) // Create Film with bookmark as true
        DataManager.shared.updateFilm(film: filmBrief1) //Update film should save film, if not already stored

        //Test
        let bookmarkValueBeforeTest = DataManager.shared.fetchFilm(id: id)!.bookmark
        
        let filmBrief2 = FilmBrief(id: 550, title: "Film", posterPath: "url", notes: nil, bookmark: false, viewed: true) // Create Film
        DataManager.shared.updateFilm(film: filmBrief2) //Update film should update changes
        
        let bookmarkValueAfterTest = DataManager.shared.fetchFilm(id: id)!.bookmark
        
        //Result
        XCTAssertNotEqual(bookmarkValueBeforeTest, bookmarkValueAfterTest)
        
        
        //Clean Up
        DataManager.shared.deleteFilm(for: id)
    }
    
    func testGivenFilmsIsStored_WhenDetailsAreAllSetToNil_ThenFilmShouldBeDeleted() {
        //Setup
        let id = 550 //RandomFilm ID
        DataManager.shared.deleteFilm(for: id) //Ensure Film is not already stored
        let filmBrief1 = FilmBrief(id: 550, title: "Film", posterPath: "url", notes: nil, bookmark: true, viewed: true) // Create Film
               DataManager.shared.updateFilm(film: filmBrief1)
        
        //Test
        let filmsBeforeTest = DataManager.shared.fetchFilmHistory()!.count
        
        let filmBrief2 = FilmBrief(id: 550, title: "Film", posterPath: "url", notes: nil, bookmark: false, viewed: false) // Set all params as false or nil
               DataManager.shared.updateFilm(film: filmBrief2) //Update film should delete film when params are nil
       
        
        let filmsAfterTest = DataManager.shared.fetchFilmHistory()!.count
        
        //Result
        XCTAssert(filmsAfterTest == filmsBeforeTest - 1)
        
        
        //Clean Up
        DataManager.shared.deleteFilm(for: id)
    }
    

}
