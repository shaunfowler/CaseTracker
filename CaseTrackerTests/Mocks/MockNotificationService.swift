//
//  MockNotificationService.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 4/5/22.
//

import Foundation
@testable import Case_Tracker

class MockNotificationService: NotificationServiceProtocol {

    var onRequestCalled: ((Case_Tracker.Notification) -> Void)?

    func request(notification: Case_Tracker.Notification) {
        onRequestCalled?(notification)
    }
}
