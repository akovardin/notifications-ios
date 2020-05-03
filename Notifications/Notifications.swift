//
// Created by Artem Kovardin on 04.05.2020.
// Copyright (c) 2020 Alexey Efimov. All rights reserved.
//

import Foundation
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    let center = UNUserNotificationCenter.current()

    func requestAuthorisation() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted: \(granted)")

            guard granted else {
                return
            }

            self.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        center.getNotificationSettings { settings in
            print("Notification settings : \(settings)")
        }
    }

    func scheduleNotification(type: String) {
        let userAction = "User Action"

        let content = UNMutableNotificationContent()

        content.title = type
        content.body = "Example notification " + type
        content.sound = .default
        content.badge = 1 // красный бейджик на иконке с кол-вом непрочитанных сообщений
        content.categoryIdentifier = userAction

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let id = "Local Notification #1"

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }

        let snoozeAction = UNNotificationAction(identifier: "snooze", title: "Snooze")
        let deleteAction = UNNotificationAction(identifier: "delete", title: "Delete", options: [.destructive])

        let category = UNNotificationCategory(
                identifier: userAction,
                actions: [snoozeAction, deleteAction],
                intentIdentifiers: [],
                options: .customDismissAction)

        center.setNotificationCategories([category])
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> ()) {
        completionHandler([.alert, .sound])

    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> ()) {
        if response.notification.request.identifier == "Local Notification #1" {
            print("Received notification Local Notification #1")
        }

        print(response.actionIdentifier)

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss action")
        case UNNotificationDefaultActionIdentifier:
            print("Default action")
        case "snooze":
            print("snooze")
            scheduleNotification(type: "Reminder")
        case "delete":
            print("delete")
        default:
            print("undefined")
        }

        completionHandler()
    }
}