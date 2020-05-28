//
//  Clip+Convenience.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

extension Clip {
    @discardableResult convenience init(title: String,
                     startTimestamp: Date,
                     audioFile: URL?,
                     context: NSManagedObjectContext) {
        // Magic happens here
        self.init(context: context)

        self.title = title
        self.startTimestamp = startTimestamp
        self.audioFile = audioFile
    }
}
