//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/20/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

enum EntryMood: String, CaseIterable {
    case happy = "🥰"
    case neutral = "😕"
    case unhappy = "😤"
}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        guard let id = identifier,
            let title = title,
            let bodyText = bodyText,
            let timestamp = timestamp,
            let mood = mood else {
                return nil
        }
        
        return EntryRepresentation(title: title,
                                   bodyText: bodyText,
                                   timestamp: timestamp,
                                   indentifier: id.uuidString,
                                   mood: mood)
    }
    
    @discardableResult convenience init(title: String,
                                        bodyText: String,
                                        timestamp: Date = Date(),
                                        identifier: UUID = UUID(),
                                        mood: EntryMood = .neutral,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
}

