//
//  NotificationService.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import NotificationCenter
import CocoaLumberjack

public class NotificationService {

    let factory = NotificationFactory()

    public init() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { result, error in
                DDLogInfo("Result from notification authorization request: \(result).")
                if let error = error {
                    DDLogError(
                        "Error from notification authorization request: \(error.localizedDescription).")
                }
            }

        // DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
        //    self.request(notification: .statusUpdated(PreviewDataRepository.case1))
        // }
    }

    public func request(notification: Notification) {

        DDLogInfo("Displaying local notification.")

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: factory.create(notification),
            trigger: nil)

        UNUserNotificationCenter.current().add(request)
    }
}
