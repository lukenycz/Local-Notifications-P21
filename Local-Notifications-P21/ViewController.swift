//
//  ViewController.swift
//  Local-Notifications-P21
//
//  Created by Łukasz Nycz on 17/08/2021.
//
import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(registerLocal))
    }


    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("yay")
            } else {
                print("oh no")
            }
        }
        
        
    }
    @objc func scheduleLocal() {
        registerCategories()
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up Call"
        content.body = "The early bird catches the worm, but second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
     //   let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        let reminder = UNMutableNotificationContent()
        reminder.title = "Reminder"
        reminder.body = "every 24h"
        reminder.categoryIdentifier = "reminder"
        reminder.sound = .default
        
        let remindTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: true)
        let remindRequest = UNNotificationRequest(identifier: UUID().uuidString, content: reminder, trigger: remindTrigger)
        center.add(remindRequest)
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let reminder = UNNotificationAction(identifier: "reminder", title: "Reminder every 24h...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default identifier")
            case "show":
                print("show more info...")
            case "reminder":
                print("remind every 24h")
            default:
                break
            }
        }
        completionHandler()
    }
}

