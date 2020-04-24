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
// extending functionality of the core data model
extension Entry {
    // to create a local save
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
                                   identifier: id.uuidString,
                                   mood: mood)
    }
    
    // turning my core data model into something that firebase can understand
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
    
    // representing the json object based on our core data model that we extended from the entry class so that way swift knows what to expect from firebase, via entryRepresentation
    // firebase data model being coverted into a coredata model
    // we are telling Entry core data expect and entry representation which is the struct model we wrote for our json
    @discardableResult convenience init?(entryRepresentation: EntryRepresentation, context: NSManagedObjectContext) {
        guard let mood = EntryMood(rawValue: entryRepresentation.mood),
            let indentifier1 = UUID(uuidString: entryRepresentation.identifier) else {
                return nil
                
                
                
        }
        self.init(title: entryRepresentation.title,
        bodyText: entryRepresentation.bodyText,
        timestamp: entryRepresentation.timestamp,
        identifier: indentifier1,
        mood: mood,
        context: context)
        
                  
    }
}

