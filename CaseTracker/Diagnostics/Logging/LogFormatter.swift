//
//  LogFormatter.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import CocoaLumberjack

class OSLogFormatter: NSObject, DDLogFormatter {

    var formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    func format(message logMessage: DDLogMessage) -> String? {
        let l = logMessage
        return "[\(l.fileName):\(l.function ?? "<fn>"):\(l.line)] \(l.message)"
    }
}

class FileLogFormatter: NSObject, DDLogFormatter {

    var formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()

    func format(message logMessage: DDLogMessage) -> String? {
        let l = logMessage
        return "\(l.timestamp) [\(l.fileName):\(l.function ?? "<fn>"):\(l.line)] \(l.message)    (\(l.queueLabel))"
    }
}
