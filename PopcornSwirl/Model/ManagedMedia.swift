//
//  ManagedMedia.swift
//  PopcornSwirl
//
//  Created by Michael Gresham on 22/06/2020.
//  Copyright © 2020 Michael Gresham. All rights reserved.
//

import Foundation
import CoreData


class ManagedMedia: NSManagedObject {
    static var entityName: String { return "ManagedMedia" }
    
    // Attributes
    @NSManaged var id: Int
    @NSManaged var bookmark: Bool
    @NSManaged var viewed: Bool
    @NSManaged var notes: String
    @NSManaged var lastModified: Date
}
