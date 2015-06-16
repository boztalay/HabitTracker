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
    var persistenceController: PersistenceController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.persistenceController = PersistenceController() {
            println("Persistence controller initialized")
            
            let rootViewController = self.window?.rootViewController as! UINavigationController
            let habitsViewController = rootViewController.viewControllers.first as! HabitsViewController
            habitsViewController.managedObjectContext = self.persistenceController?.managedObjectContext
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        self.persistenceController?.save()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        self.persistenceController?.save()
    }

    func applicationWillTerminate(application: UIApplication) {
        self.persistenceController?.save()
    }
}

