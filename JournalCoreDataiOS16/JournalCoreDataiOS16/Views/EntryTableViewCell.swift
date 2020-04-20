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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let entry = entry else { return }
        
        titleLabel.text = entry.title
        dateLabel.text = "\(String(describing: entry.timestamp))"
        bodyTextLabel.text = entry.bodyText
    }
}
