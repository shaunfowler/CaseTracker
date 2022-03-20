//
//  Notification.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import Foundation
import UserNotifications

public enum Notification {
    case statusUpdated(CaseStatus)
}

class NotificationFactory {

    func create(_ notification: Notification) -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "case-tracker-default"

        switch notification {
        case .statusUpdated(let caseStatus):
            let subtitle: String
            if let formType = caseStatus.formType {
                subtitle = "\(formType) - \(caseStatus.id)"
            } else {
                subtitle = caseStatus.id
            }

            content.title = "Case Status Updated"
            content.subtitle = subtitle
            content.body = "Your case status changed to \"\(caseStatus.status)\"."
            content.sound = UNNotificationSound.default
        }

        return content
    }
}
