//
//  Event+Convenience.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation
import CoreData

extension Event {
    @discardableResult convenience init(name: String,
                                        timestamp: Date,
                                        context: NSManagedObjectContext) {

        self.init(context: context)

        self.name = name
        self.timestamp = timestamp
    }
}
