//
//  TodayViewController.swift
//  HabitTrackerWidget
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit
import NotificationCenter

class HackerTrackerWidgetViewController: UIViewController, NCWidgetProviding {
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView?
    
    // MARK: Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    // MARK: Updating
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    // MARK: Etc
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Got memory warning")
    }
    
}

extension HackerTrackerWidgetViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return
    }
}

extension HackerTrackerWidgetViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}