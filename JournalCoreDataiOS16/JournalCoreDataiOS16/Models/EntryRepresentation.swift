//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/22/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation


//this struct means the entry representation from firebase, since coredata and fire base dont share the same types they cannot communicate we use this struct to do that for them, intermediary struct- translator between coredata and json
// we pass this into our convience init to a form that coredata can understand
struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var timestamp: Date
    var identifier: String
    var mood: String
}
