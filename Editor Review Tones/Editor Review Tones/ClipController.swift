//
//  ClipController.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

class ClipController {

    // MARK: - Properities
    var clips: [Clip] {
        // Gets loaded each time. This is a get.
        // TODO: ? Is this a performance issue.
        loadFromPersistentStore()
    }

    // MARK: CRUD

    // Create
    func create(eventWithName name: String,
                clip: Clip,
                timestamp: Date = Date()) {

        Event(name: name,
              timestamp: timestamp,
              clip: clip,
              context: CoreDataStack.shared.mainContext)

        saveToPersistentStore()
    }

    func create(clipWithTitle title: String,
                startTimestamp: Date?,
                audioFile: URL?) {

        var datetime = Date()
        if startTimestamp != nil {
            datetime = startTimestamp!
        }

        Clip(title: title,
             startTimestamp: datetime,
             audioFile: audioFile,
             context: CoreDataStack.shared.mainContext)

        saveToPersistentStore()
    }

    private func saveToPersistentStore() {
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed error context: \(error)")
        }
    }

    // Read
    private func loadFromPersistentStore() -> [Clip] {
        let fetchRequest: NSFetchRequest<Clip> = Clip.fetchRequest()

        do {
            return try CoreDataStack.shared.mainContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching clips: \(error)")
        }
        return []
    }

    // Update
    func update(clip: Clip,
                title: String,
                startTimestamp: Date,
                audioFile: URL?) {

        clip.title = title
        clip.startTimestamp = startTimestamp
        clip.audioFile = audioFile

        saveToPersistentStore()
    }

    // Delete
    func delete(clip: Clip) {

        // TODO: Delete audio clip.

        CoreDataStack.shared.mainContext.delete(clip)

        saveToPersistentStore()
    }
}
