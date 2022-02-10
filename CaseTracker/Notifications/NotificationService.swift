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

    let factory = NotificationFactory()

    init() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
                Logger.notifications.log("Result from notification authorization request: \(result, privacy: .public).")
                if let error = error {
                    Logger.notifications.error(
                        "Error from notification authorization request: \(error.localizedDescription, privacy: .public).")
                }
            }
    }

    public func request(notification: Notification) {

        Logger.notifications.log("Displaying local notification.")

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: factory.create(notification),
            trigger: nil)

        UNUserNotificationCenter.current().add(request)
    }
}
