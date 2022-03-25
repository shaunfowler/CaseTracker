//
//  AppDelegate.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import UIKit
import CocoaLumberjack
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        setupLogging()
        setupFirebase()
        setupNotifications()
        setupAppearance()
        return true
    }

    private func setupLogging() {
        print(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Caches/Logs") ?? "")

        // File logger
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 48; // 48-hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.logFormatter = FileLogFormatter()
        DDLog.add(fileLogger)

        // OSLog
        DDOSLogger.sharedInstance.logFormatter = OSLogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)

        // Crashlytics
        DDLog.add(CrashlyticsLogger(), with: .all)
    }

    private func setupFirebase() {
        FirebaseApp.configure()
        // Prime feature service
        _ = FeatureService.shared.isEnabled(feature: .history)
    }

    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
    }

    private func setupAppearance() {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(.ctTextPrimary)]
        UINavigationBar.appearance().largeTitleTextAttributes = attributes
        UINavigationBar.appearance().titleTextAttributes = attributes
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
