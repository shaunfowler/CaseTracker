//
//  CrashlyticsLogger.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/19/22.
//

import Foundation
import CocoaLumberjack
import FirebaseCrashlytics

class CrashlyticsLogger: DDAbstractLogger {

    override init() {
        super.init()
        logFormatter = DDLogFileFormatterDefault()
    }

    override func log(message: DDLogMessage) {
        guard
            let formatter = value(forKey: "_logFormatter") as? DDLogFormatter,
            let logText = formatter.format(message: message) else {
                return
            }

        Crashlytics.crashlytics().log(logText)
    }
}
