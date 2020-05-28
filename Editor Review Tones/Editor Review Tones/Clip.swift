//
//  Clip.swift
//  Editor Review Tones
//
//  Created by Mark Gerrior on 5/28/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import Foundation

class Event {
    var name: String
    var timestamp: Date

    init(name: String, timestamp: Date) {
        self.name = name
        self.timestamp = timestamp
    }
}

class Clip {
    var name: String
    var startTimestamp: Date

    var events: [Event]?

    init(name: String, startTimestamp: Date) {
        self.name = name
        self.startTimestamp = startTimestamp
        events = nil
    }
}
