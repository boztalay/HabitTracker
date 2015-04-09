//
//  NewHabitEventViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/8/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class NewHabitEventViewController: UITableViewController {
    
    // MARK: Model
    
    var habit: Habit?
    
    // MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker?
    @IBOutlet weak var numTimesTextField: UITextField?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Creating the new habit event
    
    @IBAction func doneButtonPressed() {
        let numTimes = self.numTimesTextField?.text.toInt()
        let date = self.datePicker!.date
        
        if let numTimes = numTimes {
            if date.compare(NSDate()) == .OrderedAscending {
                self.createHabitEventWithDate(date, numTimes: numTimes)
            } else {
                self.showBadDateAlertView()
            }
        } else {
            self.showBadNumberAlertView()
        }
    }
    
    func createHabitEventWithDate(date: NSDate, numTimes: Int) {
        SugarRecord.operation(inBackground: true, stackType: .SugarRecordEngineCoreData) { (context) -> () in
            if let habit = self.habit {
                let newHabitEvent = HabitEvent.create() as! HabitEvent
                newHabitEvent.date = date
                newHabitEvent.numTimes = Int32(numTimes)
                newHabitEvent.habit = habit
                newHabitEvent.save()
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.dismissSelf()
            }
        }
    }
    
    func showBadDateAlertView() {
        let alertView = UIAlertView(title: "Bad Date", message: "Enter a past date!", delegate: nil, cancelButtonTitle: "Ugh, fine")
        alertView.show()
    }
    
    func showBadNumberAlertView() {
        let alertView = UIAlertView(title: "NaN", message: "Enter a valid number of times!", delegate: nil, cancelButtonTitle: "That's totally a number!")
        alertView.show()
    }
    
    // MARK: Canceling
    
    @IBAction func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
