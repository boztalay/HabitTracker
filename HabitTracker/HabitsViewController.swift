//
//  HabitsViewController.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

class HabitsViewController: UITableViewController {
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
        SugarRecord.addStack(stack)
        
        self.title = "Habits"
        
        self.tableView.registerClass(HabitTableViewCell.self, forCellReuseIdentifier: HabitTableViewCell.ReuseIdentifier())
    }
    
    // MARK: Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let habitCell = tableView.dequeueReusableCellWithIdentifier(HabitTableViewCell.ReuseIdentifier()) as HabitTableViewCell
        
        let white: CGFloat = (CGFloat(indexPath.row + 1) / 10.0)
        habitCell.backgroundColor = UIColor(white: white, alpha: 1.0)
        
        return habitCell
    }
    
    // MARK: Table view delegate
}
