//
//  AppDelegate.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import UIKit
import OSLog

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
        Logger.main.info("AppDelegate - didFinishLaunchingWithOptions")
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
    ) -> Void) {
        Logger.main.log("Local notification delegate received willPresent.")
        completionHandler([.sound, .badge, .banner])
    }
}
