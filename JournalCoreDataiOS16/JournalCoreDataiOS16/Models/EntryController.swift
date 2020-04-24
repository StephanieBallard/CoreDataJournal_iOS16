//
//  EntryController.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/22/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

class EntryController {
    
    let baseURL = URL(string: "https://journal-170c8.firebaseio.com")!
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func sendEntryToServer(entry: Entry, completion: @escaping CompletionHandler = { _ in}) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            NSLog("Error encoding task \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                NSLog("Error sending task to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    func deleteEntryFromServer(entry: Entry, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                NSLog("Error deleting entry from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }
    
    // freshly fetched data is being passed in via the EntryRepresentation
    private func updateEntries(with representations: [EntryRepresentation]) throws {
        
        // setting up the comparison to local files
        let identifiersToFetch = representations.compactMap { UUID(uuidString: $0.identifier) }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.mainContext
        // take all the identifiers and compare them to the ones we already have and if they match we ignore it bc it means we already have the correct data, if it does not match it turns it into core data so we can store it locally
        do {
            let existingEntries = try context.fetch(fetchRequest)
            // bc firebase is the truth we are updating our core data with the translated json
            // checking what we have in core data, update the other parameters if the id matches
            for entry in existingEntries {
                guard let id = entry.identifier,
                    let representation = representationsByID[id] else { continue }
                self.update(entry: entry, with: representation)
                entriesToCreate.removeValue(forKey: id)
            }
            // running the init that receives a firebase object and converts it into something that core data understands
            // running for loop of each of the pieces of data that we pull from firebase and turning them into coredata objects that can be stored locally
            for representation in entriesToCreate.values {
                // when we call entry we are init a core date object w/ a json object using the convenience init that converts it and providing the main context that our codedata is saved on which is coredatestack.shared.maincontext
                
                // core data needs a context to function
                
                // when this runs, behind the scenes it is running the convience init, which gives us a fresh core data obj and we have access to it's context and it can now be presented to the user
                Entry(entryRepresentation: representation, context: context)
            }
        } catch {
            NSLog("Error fetching tasks with UUIDs: \(identifiersToFetch), with error: \(error)")
        }
        
        try CoreDataStack.shared.mainContext.save()
    }
    
    private func update(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.timestamp = representation.timestamp
        entry.mood = representation.mood
    }
}


