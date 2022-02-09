//
//  NotificationService.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import NotificationCenter
import OSLog

class NotificationService {

    init() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
                Logger.notifications.info("Result from notification authorization request: \(result).")
                if let error = error {
                    Logger.notifications.error(
                        "Error from notification authorization request: \(error.localizedDescription).")
                }
            }
    }

    public func display(title: String, subtitle: String? = nil, message: String) {

        Logger.notifications.info("Displaying local notification.")
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.categoryIdentifier = "nc1"
        if let subtitle = subtitle {
            content.subtitle = subtitle
        }
        content.sound = UNNotificationSound.default
        content.body = message

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
}
