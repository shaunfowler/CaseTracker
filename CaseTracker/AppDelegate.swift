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

@main
class AppDelegate: NSObject, UIApplicationDelegate {

    // MARK: UIApplicationDelegate

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

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Private Functions

    private func setupLogging() {
        // OSLog
        DDOSLogger.sharedInstance.logFormatter = OSLogFormatter()
        DDLog.add(DDOSLogger.sharedInstance)

#if DEBUG
        if CommandLine.arguments.contains("-uiTests") { return }
#endif

        // File logger
        print(FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first?.appendingPathComponent("Caches/Logs") ?? "")
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 48; // 48-hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        fileLogger.logFormatter = FileLogFormatter()
        DDLog.add(fileLogger)

        // Crashlytics
        DDLog.add(CrashlyticsLogger(), with: .all)
    }

    private func setupFirebase() {
#if DEBUG
        if CommandLine.arguments.contains("-uiTests") { return }
#endif
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

#if DEBUG
        if CommandLine.arguments.contains("-uiTests") {
            UIView.setAnimationsEnabled(false)
        }
#endif
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        DDLogInfo("Local notification delegate received willPresent.")
        completionHandler([.sound, .badge, .banner])
    }
}
