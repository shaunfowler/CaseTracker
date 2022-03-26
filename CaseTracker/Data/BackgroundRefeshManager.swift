//
//  BackgroundRefeshManager.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import BackgroundTasks
import CocoaLumberjack

// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.shaunfowler.CaseTracker-reload"]

// swiftlint:disable class_delegate_protocol
protocol BackgroundRefreshableDelegate {
    func refresh() async
}
// swiftlint:enable class_delegate_protocol

class BackgroundRefeshManager {

    private enum Constants {
        static let reloadTaskId = "com.shaunfowler.CaseTracker-reload"
        static let timeDelay: TimeInterval = 2 * 60 * 60 // 2 hours
    }

    /// Not weak as value types can register as receiver.
    var delegate: BackgroundRefreshableDelegate?

    init() {
        DDLogInfo("Registering task: \(Constants.reloadTaskId).")
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Constants.reloadTaskId,
            using: nil) { task in
                if let refreshTask = task as? BGAppRefreshTask {
                    self.handleAppRefreshTask(task: refreshTask)
                }
            }
    }

    func schedule() {
        DDLogInfo("Attempting to schedule background refresh task...")
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Constants.reloadTaskId)
        do {
            let request = BGAppRefreshTaskRequest(identifier: Constants.reloadTaskId)
            let date = Date(timeIntervalSinceNow: Constants.timeDelay)
            request.earliestBeginDate = date
            try BGTaskScheduler.shared.submit(request)
            DDLogInfo("Scheduled task: \(Constants.reloadTaskId).")
            DDLogInfo(
                "Earliest begin date of: \(date.description). Now: \(Date().description).")
        } catch {
            DDLogError(
                "Failed to submit background task: \(Constants.reloadTaskId). Error: \(error.localizedDescription)")
        }
    }

    private func handleAppRefreshTask(task: BGAppRefreshTask) {
        DDLogInfo("Executing background task: \(Constants.reloadTaskId)...")
        Task {
            await delegate?.refresh()
            DDLogInfo("Completed background task: \(Constants.reloadTaskId).")
            schedule()
            task.setTaskCompleted(success: true)
        }
    }
}
