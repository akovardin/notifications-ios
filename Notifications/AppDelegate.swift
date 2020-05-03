//
//  AppDelegate.swift
//  Notifications
//
//  Created by Alexey Efimov on 21.06.2018.
//  Copyright © 2018 Alexey Efimov. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let notifications = UNUserNotificationCenter.current()
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestAuthorisation()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func requestAuthorisation() {
        notifications.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")

            guard granted else {
                return
            }

            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        notifications.getNotificationSettings { settings in
            print("Notification settings : \(settings)")
        }
    }

    func scheduleNotification(type: String) {
        let content = UNMutableNotificationContent()

        content.title = type
        content.body = "Example notification " + type
        content.sound = .default
        content.badge = 1 // красный бейджик на иконке с кол-вом непрочитанных сообщений

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let id = "Local Notification #1"

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        notifications.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }

}

