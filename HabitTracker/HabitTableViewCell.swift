//
//  HabitTableViewCell.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var countLabel: UILabel?
    
    // MARK: Constants
    
    class func ReuseIdentifier() -> String {
        return "HabitCell"
    }
    
    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
