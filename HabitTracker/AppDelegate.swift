//
//  AppDelegate.swift
//  HabitTracker
//
//  Created by Ben Oztalay on 4/5/15.
//  Copyright (c) 2015 Ben Oztalay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let stack: DefaultCDStack = DefaultCDStack(databaseName: "Database.sqlite", automigrating: true)
        stack.autoSaving = true
        SugarRecord.addStack(stack)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        SugarRecord.applicationWillResignActive()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        SugarRecord.applicationWillEnterForeground()
    }

    func applicationWillTerminate(application: UIApplication) {
        SugarRecord.applicationWillTerminate()
    }
}

