//
//  HabitEvent.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import Foundation
import CoreData

class HabitEvent: NSManagedObject {
    
    @NSManaged var date: NSDate
    @NSManaged var numTimes: Int32
    @NSManaged var habit: Habit
}