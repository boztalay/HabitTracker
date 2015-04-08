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
        
        self.tableView?.allowsMultipleSelectionDuringEditing = false

        self.updateTableViewVisibility()
    }
    
    // MARK: Displaying different views based on the state of the habit
    
    func updateTableViewVisibility() {
        if let habit = self.habit {
            if habit.events.count > 0 {
                self.showTableView()
                return
            }
        }
        
        self.showNoDataLabel()
    }
    
    func showTableView() {
        self.tableView?.hidden = false
        self.noDataLabel?.hidden = true
    }
    
    func showNoDataLabel() {
        self.tableView?.hidden = true
        self.noDataLabel?.hidden = false
    }
    
    // MARK: Adding a new habit event
    
    @IBAction func addNewHabitButtonPressed(sender: AnyObject) {
        self.tableView?.editing = false
        
        // TODO bring up the new habit event screen
    }
    
    // MARK: Removing habit events
    
    func deleteHabitEvent(habitEvent: HabitEvent) {
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            habitEvent.beginWriting().delete().endWriting()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.updateTableViewVisibility()
                self.tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            }
        }
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
        let habitEvent = habit?.events[habit!.events.count - indexPath.row - 1] as HabitEvent
        
        habitEventCell.setHabitEvent(habitEvent)
        
        return habitEventCell
    }
}

extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let habitEventToDelete = self.habit!.events[indexPath.row] as HabitEvent
            self.deleteHabitEvent(habitEventToDelete)
        }
    }
}
