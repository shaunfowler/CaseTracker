//
//  BackgroundRefesher.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import BackgroundTasks
import OSLog

// e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.shaunfowler.CaseTracker-reload"]

protocol BackgroundRefreshableDelegate {
    func refresh() async
}

class BackgroundRefeshManager {

    private enum Constants {
        static let reloadTaskId = "com.shaunfowler.CaseTracker-reload"
        static let timeDelay: TimeInterval = 4 * 60 * 60 // 4 hours
    }

    /// Not weak as value types can register as receiver.
    var delegate: BackgroundRefreshableDelegate?

    init() {
        Logger.background.log("Registering task: \(Constants.reloadTaskId).")
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: Constants.reloadTaskId,
            using: nil) { task in
                if let refreshTask = task as? BGAppRefreshTask {
                    self.handleAppRefreshTask(task: refreshTask)
                }
            }
    }

    func schedule() {
        do {
            let request = BGAppRefreshTaskRequest(identifier: Constants.reloadTaskId)
            let date = Date(timeIntervalSinceNow: Constants.timeDelay)
            request.earliestBeginDate = date
            try BGTaskScheduler.shared.submit(request)
            Logger.background.log("Scheduled task: \(Constants.reloadTaskId).")
            Logger.background.log("Earliest begin date of: \(date.description). Now: \(Date().description).")
        } catch {
            Logger.background.error(
                "Failed to submit background task: \(Constants.reloadTaskId). Error: \(error.localizedDescription)")
        }
    }

    private func handleAppRefreshTask(task: BGAppRefreshTask) {
        Logger.background.log("Executing background task: \(Constants.reloadTaskId)...")
        Task {
            await delegate?.refresh()
            Logger.background.log("Completed background task: \(Constants.reloadTaskId).")
            schedule()
            task.setTaskCompleted(success: true)
        }
    }
}
