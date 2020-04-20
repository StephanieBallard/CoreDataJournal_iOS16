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
        
        Entry(title: title, bodyText: bodyText)
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
            return
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

