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

