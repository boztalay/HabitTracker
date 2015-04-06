//
//  HabitAnalysisTableViewCell.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/6/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitAnalysisTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var numEventsLabel: UILabel?
    
    // MARK: Constants
    
    class func ReuseIdentifier() -> String {
        return "HabitAnalysisCell"
    }
    
    // MARK: Setting the views for a habit analysis
    
    func setHabitAnalysis(habitAnalysis: HabitTimeframeAnalysis) {
        self.nameLabel?.text = habitAnalysis.readableName
        self.numEventsLabel?.text = "\(habitAnalysis.numEventsInTimeframe)"
    }
}
