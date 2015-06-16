//
//  HabitViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/6/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitOverviewViewController: UIViewController {
    
    // MARK: Model
    
    var habit: Habit?
    var habitAnalyzer: HabitTimeframeAnalyzer?
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.title = habit?.name
        
        self.runHabitAnalysis()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func runHabitAnalysis() {
//        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
//            if let habit = self.habit {
//                self.habitAnalyzer = HabitTimeframeAnalyzer(habit: habit)
//                self.habitAnalyzer?.addAndRunAllAnalyses()
//                
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.tableView?.reloadData()
//                }
//            }
//        }
    }
}

extension HabitOverviewViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let habitAnalyzer = self.habitAnalyzer {
            return habitAnalyzer.analyses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let habitAnalysisCell = tableView.dequeueReusableCellWithIdentifier(HabitAnalysisTableViewCell.ReuseIdentifier()) as! HabitAnalysisTableViewCell
        let habitAnalysis = self.habitAnalyzer!.analyses[indexPath.row]
        
        habitAnalysisCell.setHabitAnalysis(habitAnalysis)
        
        return habitAnalysisCell
    }
}
