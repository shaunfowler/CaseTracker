//
//  Logger.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let main = Logger(subsystem: subsystem, category: "main")
    static let view = Logger(subsystem: subsystem, category: "view")
    static let api = Logger(subsystem: subsystem, category: "api")
    static let background = Logger(subsystem: subsystem, category: "background")
    static let notifications = Logger(subsystem: subsystem, category: "notifications")
}
