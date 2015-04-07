//
//  HabitDetailsViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/7/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    // MARK: Model
    
    var habit: Habit?
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var noDataLabel: UILabel?
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension HabitDetailsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let habit = self.habit {
            return habit.events.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let habitEventCell = tableView.dequeueReusableCellWithIdentifier(HabitEventTableViewCell.ReuseIdentifier()) as HabitEventTableViewCell
        let habitEvent = habit?.events[indexPath.row] as HabitEvent
        
        habitEventCell.setHabitEvent(habitEvent)
        
        return habitEventCell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    
}
