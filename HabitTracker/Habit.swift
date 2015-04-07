//
//  Habit.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import Foundation
import CoreData

class Habit: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var events: NSOrderedSet
}
