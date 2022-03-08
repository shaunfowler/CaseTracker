//
//  AppDelegate.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import UIKit
import CocoaLumberjack

#if UIKIT
@main
class AppDelegate: NSObject { }
#else
class AppDelegate: NSObject { }
#endif

extension AppDelegate: UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        setupLogging()
        return true
    }

    private func setupLogging() {
        print(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Caches/Logs") ?? "")

        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 48; // 48-hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7

        DDOSLogger.sharedInstance.logFormatter = OSLogFormatter()
        fileLogger.logFormatter = FileLogFormatter()

        DDLog.add(DDOSLogger.sharedInstance)
        DDLog.add(fileLogger)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
    ) -> Void) {
        DDLogInfo("Local notification delegate received willPresent.")
        completionHandler([.sound, .badge, .banner])
    }
}
