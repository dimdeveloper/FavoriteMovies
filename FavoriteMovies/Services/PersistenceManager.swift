//
//  PersistenceManager.swift
//  FavoriteMovies
//
//  Created by Dmytro Melnyk on 26.04.2025.
//

import Foundation
import CoreData

class PersistenceManager {
    static let shared = PersistenceManager()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "MovieStore")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load CoreData store: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }
}
