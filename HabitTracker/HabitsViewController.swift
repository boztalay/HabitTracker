//
//  HabitsViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitsViewController: UIViewController, UIAlertViewDelegate {
    
    // MARK: Model
    
    var habits: SugarRecordResults?
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var noHabitsLabel: UILabel?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchFirstData()
    }
    
    // MARK: Fetching data
    
    func fetchFirstData() {
        self.tableView?.hidden = true
        self.noHabitsLabel?.hidden = true
        self.loadingIndicator?.startAnimating()
        
        self.fetchData()
    }
    
    func fetchData() {
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            self.habits = Habit.all().sorted(by: "name", ascending: true).find()

            dispatch_async(dispatch_get_main_queue()) {
                self.updateTableViewVisibility()
                self.tableView?.reloadData()
            }
        }
    }
    
    // MARK: Putting the views into various states
    
    func updateTableViewVisibility() {
        self.loadingIndicator?.stopAnimating()
        
        if let habits = self.habits {
            if habits.count > 0 {
                self.showTableView()
                return
            }
        }
        
        self.showNoHabitsLabel()
    }
    
    func showTableView() {
        self.noHabitsLabel?.hidden = true
        self.tableView?.hidden = false
    }
    
    func showNoHabitsLabel() {
        self.noHabitsLabel?.hidden = false
        self.tableView?.hidden = true
    }
    
    // MARK: Adding a new habit
    
    @IBAction func addNewHabitButtonPressed(sender: AnyObject) {
        var alertView = UIAlertView(title: "New Habit", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
                let newHabit = Habit.create() as Habit
                newHabit.name = alertView.textFieldAtIndex(0)!.text
                newHabit.save()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.fetchData()
                }
            }
        }
    }
    
    // MARK: Tracking another occurance of an existing habit
    
    @IBAction func trackButtonPressed(sender: AnyObject) {
        let trackButton = sender as UIButton
        
        let centerOfButtonRelativeToTableView = trackButton.convertPoint(CGPointZero, toView: self.tableView!)
        let indexPathOfRowPressed = self.tableView?.indexPathForRowAtPoint(centerOfButtonRelativeToTableView)
        let habit = self.habits![indexPathOfRowPressed!.row] as Habit
        
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            let newHabitEvent = HabitEvent.create() as HabitEvent
            newHabitEvent.numTimes = 1
            newHabitEvent.date = NSDate()
            newHabitEvent.habit = habit
            newHabitEvent.save()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.fetchData()
            }
        }
    }
}

extension HabitsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let habits = self.habits {
            return habits.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let habitCell = tableView.dequeueReusableCellWithIdentifier(HabitTableViewCell.ReuseIdentifier()) as HabitTableViewCell
        let habit = self.habits![indexPath.row] as Habit
        
        habitCell.nameLabel?.text = habit.name
        habitCell.countLabel?.text = "\(habit.events.count)"
        
        return habitCell
    }
}

extension HabitsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
}
