//
//  EntryTableViewCell.swift
//  Journal
//
//  Created by Stephanie Ballard on 4/20/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "EntryCell"
    
    var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let entry = entry,
            let timestamp = entry.timestamp else { return }
        
        titleLabel.text = entry.title
        bodyTextLabel.text = entry.bodyText
        let entryTimestamp = dateFormatter.string(from: timestamp)
        dateLabel.text = entryTimestamp
        
        
    }
}

