//
//  CoreDataStack.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    /// Singleton. Only do once. Sharing state. Not _that_ expensive.
    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Clip")
        container.loadPersistentStores { _, error  in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }

        return container
    }()

    var mainContext: NSManagedObjectContext {
        container.viewContext
    }
}
