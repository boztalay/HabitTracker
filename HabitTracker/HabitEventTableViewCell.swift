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
    
    // MARK: Constants and variables
    
    class func ReuseIdentifier() -> String {
        return "HabitEventCell"
    }
    
    var dateFormatter: NSDateFormatter?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter?.dateStyle = .MediumStyle
        self.dateFormatter?.timeStyle = .LongStyle
    }
    
    // MARK: Setting the habit event
    
    func setHabitEvent(habitEvent: HabitEvent) {
        self.dateLabel?.text = self.dateFormatter?.stringFromDate(habitEvent.date)
        self.numTimesLabel?.text = "\(habitEvent.numTimes)"
    }
}
