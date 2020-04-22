//
//  CreateEntryViewController.swift
//  JournalCoreDataiOS16
//
//  Created by Stephanie Ballard on 4/20/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class CreateEntryViewController: UIViewController {

    @IBOutlet weak var journalEntryTitle: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        journalEntryTitle.becomeFirstResponder()
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = journalEntryTitle.text,
            !title.isEmpty else { return }
        
        guard let bodyText = entryTextView.text else { return }
        let moodIndex = moodSegmentedControl.selectedSegmentIndex
        let mood = EntryMood.allCases[moodIndex]
        
        let newEntry = Entry(title: title, bodyText: bodyText, mood: mood)
        print(newEntry.mood)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

