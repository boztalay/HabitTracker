//
//  HabitTimeframeAnalysis.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/6/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import Foundation

class HabitTimeframeAnalysis {
    
    let timeframeInSeconds: Double
    let readableName: String
    var numEventsInTimeframe: Int32
    
    var analysisPending = true
    var timeframeDate: NSDate?
    
    init(timeframeInSeconds: Double, readableName: String) {
        self.timeframeInSeconds = timeframeInSeconds
        self.readableName = readableName
        self.numEventsInTimeframe = 0
    }
    
    func makeTimeframeDate() {
        self.timeframeDate = NSDate(timeInterval: -self.timeframeInSeconds, sinceDate: NSDate())
    }
}