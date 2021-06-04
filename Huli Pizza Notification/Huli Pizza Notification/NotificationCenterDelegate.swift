//
//  NotificationCenterDelegate.swift
//  HuliPizzaNotifications
//
//  Created by Steven Lipton on 10/9/18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationCenterDelegate: NSObject {
   
    
    //MARK: - Support Methods
    let surferBullet = "🏄🏽‍♀️ "
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
}
