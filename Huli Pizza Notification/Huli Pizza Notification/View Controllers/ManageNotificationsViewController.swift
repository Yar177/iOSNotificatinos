//
//  ManageNotificationsViewController.swift
//  HuliPizzaNotifications
//
//  Created by Steven Lipton on 9/27/18.
//  Copyright © 2018 Steven Lipton. All rights reserved.
//

import UIKit
import UserNotifications


class ManageNotificationsViewController: UIViewController{
    
    @IBOutlet weak var pendingNotificationButton: UIButton!
    @IBOutlet weak var consoleView: UITextView!
    
    //let pizzaSteps = ["Make pizza", "Roll Dough", "Add Sauce", "Add Cheese", "Add Ingredients", "Bake", "Done"]
    
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewPendingNotifications(_ sender: UIButton) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            self.printRequest(count: requests.count, type: "pending")
            for request in requests{
                self.printConsoleView("-->\(request.identifier): \(request.content.body) \n")
            }
        }
    }
    
    @IBAction func viewDeliveredNotifications(_ sender: UIButton) {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            self.printRequest(count: notifications.count, type: "Delivered")
            for notification in notifications{
                self.printConsoleView("-->\(notification.request.identifier): \(notification.request.content.body) \n")
            }
        }
       
    }
    
    @IBAction func removeAllNotifications(_ sender: UITapGestureRecognizer) {
       
    }
    
    @IBAction func removeNotification(_ sender: UIButton) {
        
    }
    
    @IBAction func nextPizzaStep(_ sender: UIButton) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests{
                if request.identifier.hasPrefix("message.pizza"){
                    guard let content = self.updatePizzaContent(request: request) else{
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
                        return
                    }
                    self.addNotification(trigger: request.trigger, content: content, identifier: request.identifier)
                    return
                }
            }
        }
        
    }
    
    func updatePizzaContent(request:UNNotificationRequest) -> UNMutableNotificationContent!{
        if let stepNum = request.content.userInfo["step"] as? Int {
            let newStepNum = (stepNum + 1)
            if newStepNum >= pizzaSteps.count{return nil}
            
            let updatedContent = request.content.mutableCopy() as! UNMutableNotificationContent
            updatedContent.body = pizzaSteps[newStepNum]
            updatedContent.userInfo["step"] = newStepNum
            return updatedContent
        }
        return request.content as? UNMutableNotificationContent
    }
    
    //MARK: - Life Cycle
    override func viewDidLayoutSubviews() {
        // rouds to corners of the console view
        consoleView.layer.cornerRadius = consoleView.frame.height * 0.05
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
     //MARK: - Support Methods
    func printConsoleView(_ string:String){
        DispatchQueue.main.async {
            self.consoleView.text += string
        }
    }
    func clearConsoleView(){
        DispatchQueue.main.async {
            self.consoleView.text = ""
        }
    }
    
    //a function to nicely print the date, count and type of notification.
    func printRequest(count:Int, type:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: Date())
        var countString = String(format: "%i",count)
        countString = dateString + "---->" + countString + " requests " + type + "\n"
        clearConsoleView()
        printConsoleView(countString)
    }
    
    func notificationContent(title:String,body:String)->UNMutableNotificationContent{
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.userInfo = ["step":0]
        return content
    }
    func addNotification(trigger:UNNotificationTrigger?,content:UNMutableNotificationContent,identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            self.printError(error, location: "Add Request for Identifier:" + identifier)
        }
    }
    
    // A function to print errors to the console
    func printError(_ error:Error?,location:String){
        if let error = error{
            print("Error: \(error.localizedDescription) in \(location)")
        }
    }
}
