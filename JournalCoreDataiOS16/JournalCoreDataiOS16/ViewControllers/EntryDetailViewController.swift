//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/22/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    var entry: Entry? {
        didSet {
            
        }
    }
    var wasEdited: Bool = false
    let mood: EntryMood = .neutral
    
    @IBOutlet weak var moodSegmentedControl: UISegmentedControl!
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if wasEdited {
            guard let title = entryTextField.text,
                !title.isEmpty,
                let entry = entry else {
                    return
            }
            
            let bodyText = entryTextView.text
            entry.title = title
            entry.bodyText = bodyText
            
            let moodIndex = moodSegmentedControl.selectedSegmentIndex
            entry.mood = EntryMood.allCases[moodIndex].rawValue
            
            do {
                try CoreDataStack.shared.mainContext.save()
            } catch {
                NSLog("Error saving managed object context: \(error)")
            }
        }
    }
    
    // MARK: - Editing -
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing { wasEdited = true }
        
        entryTextField.isUserInteractionEnabled = editing
        entryTextView.isUserInteractionEnabled = editing
        moodSegmentedControl.isUserInteractionEnabled = editing
        
        navigationItem.hidesBackButton = editing
    }
    
    private func updateViews() {
        if entry != nil {
            entryTextField.text = entry?.title
            entryTextField.isUserInteractionEnabled = isEditing
            
            entryTextView.text = entry?.bodyText
            entryTextView.isUserInteractionEnabled = isEditing
            
            guard let entriesMood = entry?.mood else { return }
           
           
            moodSegmentedControl.selectedSegmentIndex = EntryMood.allCases.firstIndex(of: EntryMood(rawValue: entriesMood)!)!
            moodSegmentedControl.isUserInteractionEnabled = isEditing
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
