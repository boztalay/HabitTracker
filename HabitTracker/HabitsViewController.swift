//
//  HabitsViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

//class HabitDetailsViewController : UIViewController {
//
//    override init() {
//        super.init()
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    var habit : Habit = Habit()
//
//}

class HabitsViewController: UIViewController, UIAlertViewDelegate {
    
    // MARK: Constants
    
    let ThisToHabitOverviewSegueIdentifier = "HabitsToHabitOverview"
    
    // MARK: Model
    
    var habits: SugarRecordResults?
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var noHabitsLabel: UILabel?
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.allowsMultipleSelectionDuringEditing = false
        
        self.fetchFirstData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = self.tableView?.indexPathForSelectedRow() {
            self.tableView?.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
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
                self.tableView?.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
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
        self.tableView?.editing = false
        
        let alertView = UIAlertView(title: "New Habit", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.show()
    }
    
    func alertViewConfirmedNewHabit(alertView: UIAlertView) {
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            let newHabit = Habit.create() as Habit
            newHabit.name = alertView.textFieldAtIndex(0)!.text
            newHabit.save()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.fetchData()
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
                self.tableView?.reloadData()
                var junk = 0 // SourceKit freaks out about the above line if this isn't here -.-
            }
        }
    }
    
    // MARK: Deleting a habit
    
    var habitToDelete: Habit?
    
    func deleteHabitAtIndex(habitIndex: Int) {
        habitToDelete = self.habits![habitIndex] as? Habit
        
        if let habitToDelete = self.habitToDelete {
            let alertView = UIAlertView(title: "Fo Real?", message: "Really delete '\(habitToDelete.name)'?", delegate: self, cancelButtonTitle: "Nope", otherButtonTitles: "Yes")
            alertView.show()
        }
    }
    
    func alertViewConfirmedDeleteHabit() {
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            if let habitToDelete = self.habitToDelete {
                habitToDelete.beginWriting().delete().endWriting()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.fetchData()
                }
            }
        }
    }
    
    // MARK: Moving to the habit overview controllers
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.ThisToHabitOverviewSegueIdentifier {
            let index = self.tableView?.indexPathForSelectedRow()!.row
            let habitToShowOverviewFor = self.habits![index!] as Habit
            
            let tabBarController = segue.destinationViewController as UITabBarController
            let habitOverviewController = tabBarController.viewControllers![0] as HabitOverviewViewController
            let habitDetailsController = tabBarController.viewControllers![1] as HabitDetailsViewController
            
            habitOverviewController.habit = habitToShowOverviewFor
            habitDetailsController.habit = habitToShowOverviewFor
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
        
        habitCell.setHabit(habit)
        
        return habitCell
    }
}

extension HabitsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteHabitAtIndex(indexPath.row)
        }
    }
}

extension HabitsViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if self.tableView?.editing == true {
                self.alertViewConfirmedDeleteHabit()
            } else {
                self.alertViewConfirmedNewHabit(alertView)
            }
        }
    }
}
