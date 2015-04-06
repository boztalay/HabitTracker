//
//  HabitTimeframeAnalyzer.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/6/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import Foundation

class HabitTimeframeAnalyzer {
    
    // MARK: State
    
    var habit: Habit
    var analyses: [HabitTimeframeAnalysis]
    
    // MARK: Lifecycle
    
    init(habit: Habit) {
        self.habit = habit
        self.analyses = []
    }
    
    // MARK: General analysis
    
    func addPendingAnalysisForTimeframe(timeframeInSeconds: Double, analysisName: String) {
        analyses.append(HabitTimeframeAnalysis(timeframeInSeconds: timeframeInSeconds, readableName: analysisName))
    }
    
    func runAnalysis() {
        var analysesToRun = Array(filter(self.analyses) { $0.analysisPending })
        
        // First calculate the dates that correspond to each analysis to run
        for analysisToRun in analysesToRun {
            analysisToRun.makeTimeframeDate()
        }
        
        // Now start counting events in each timeframe
        // This could be more efficient if we could iterate backwards over habit.events
        for habitEvent in habit.events {
            if let habitEvent = habitEvent as? HabitEvent {
                for analysis in analysesToRun {
                    if habitEvent.date.compare(analysis.timeframeDate!) == NSComparisonResult.OrderedDescending {
                        analysis.numEventsInTimeframe += habitEvent.numTimes
                    }
                }
            }
        }
    }
    
    // MARK: Prepackaged analysis functions
    
    func addAndRunAllAnalyses() {
        self.addLastDayAnalysis()
        self.addLastWeekAnalysis()
        self.addLastMonthAnalysis()
        self.addLastQuarterAnalysis()
        self.addLastYearAnalysis()
        self.addAllTimeAnalysis()
        
        self.runAnalysis()
    }
    
    func addLastDayAnalysis() {
//        let numSecondsInTimeframe = 24.0 * 60.0 * 60.0
        let numSecondsInTimeframe = 60.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "Last Day")
    }
    
    func addLastWeekAnalysis() {
//        let numSecondsInTimeframe = 7.0 * 24.0 * 60.0 * 60.0
        let numSecondsInTimeframe = 60.0 * 60.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "Last Week")
    }
    
    func addLastMonthAnalysis() {
        let numSecondsInTimeframe = 30.0 * 24.0 * 60.0 * 60.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "Last Month")
    }
    
    func addLastQuarterAnalysis() {
        let numSecondsInTimeframe = 3.0 * 30.0 * 24.0 * 60.0 * 60.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "Last Quarter")
    }
    
    func addLastYearAnalysis() {
        let numSecondsInTimeframe = 365.0 * 24.0 * 60.0 * 60.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "Last Year")
    }
    
    func addAllTimeAnalysis() {
        let numSecondsInTimeframe = 1000000000.0
        self.addPendingAnalysisForTimeframe(numSecondsInTimeframe, analysisName: "All Time")
    }
}