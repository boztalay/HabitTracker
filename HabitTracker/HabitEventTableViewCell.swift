//
//  HabitEventTableViewCell.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/6/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitEventTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var numTimesLabel: UILabel?
    
    // MARK: Constants
    
    class func ReuseIdentifier() -> String {
        return "HabitEventCell"
    }
}
