//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/22/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable {
    var title: String
    var bodyText: String
    var timestamp: Date
    var indentifier: String
    var mood: String
}
