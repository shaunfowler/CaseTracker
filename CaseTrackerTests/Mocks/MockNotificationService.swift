//
//  MockNotificationService.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 4/5/22.
//

import Foundation
@testable import CaseTracker

class MockNotificationService: NotificationServiceProtocol {

    var onRequestCalled: ((CaseTracker.Notification) -> Void)?

    func request(notification: CaseTracker.Notification) {
        onRequestCalled?(notification)
    }
}
