//
//  AppDelegate.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/7/22.
//

import Foundation
import UIKit
import OneSignal

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        OneSignal.setLogLevel(.LL_INFO, visualLevel: .LL_NONE)

        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("f1842f46-e799-4654-aedf-4fc5b10fc872")

        OneSignal.promptForPushNotifications { response in
            print("Response for push notification promp", response)
        }

        return true
    }
}
