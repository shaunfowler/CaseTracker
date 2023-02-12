//
//  CaseTrackerApp.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/30/22.
//

import SwiftUI
import UIKit

// @main
struct CaseTrackerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let repository: Repository
    let notificationService: NotificationService
    let backgroundRefreshManager: BackgroundRefeshManager

    @StateObject var homeViewModel: HomeViewModel

    init() {
        // Dependency tree
                self.notificationService = NotificationService()

                var repository: CaseStatusRepository
        #if DEBUG
                if CommandLine.arguments.contains("-uiTests") {
                    print("*** Using mocked remote API ***")
                    repository = CaseStatusRepository(
                        local: LocalCaseStatusPersistence(),
                        remote: UITestsRemoteCaseStatusAPI(),
                        notificationService: notificationService
                    )
                } else {
                    repository = CaseStatusRepository(notificationService: notificationService)
                }
        #else
                repository = CaseStatusRepository(notificationService: notificationService)
        #endif

                self.repository = repository

        self._homeViewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))

        self.backgroundRefreshManager = BackgroundRefeshManager()
        backgroundRefreshManager.delegate = self

        // Schedule background refresh
#if !targetEnvironment(simulator)
        backgroundRefreshManager.schedule()
#endif
    }

    private func setupAppearance() {
#if DEBUG
        let window = UIApplication.shared.keyWindow
        if CommandLine.arguments.contains("-uiTestsDarkMode") {
            window?.overrideUserInterfaceStyle = .dark
        } else if CommandLine.arguments.contains("-uiTestsLightMode") {
            window?.overrideUserInterfaceStyle = .light
        }
#endif
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
                .onAppear {
                    setupAppearance()
                }
        }
    }
}

extension CaseTrackerApp: BackgroundRefreshableDelegate {
    func refresh() async {
        await repository.query(force: false)
    }
}
