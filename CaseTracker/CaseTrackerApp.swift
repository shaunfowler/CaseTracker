//
//  CaseTrackerApp.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/30/22.
//

import SwiftUI
import SwiftSoup
import UIKit

@main
struct CaseTrackerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let repository: Repository
    let notificationService: NotificationService
    let backgroundRefreshManager: BackgroundRefeshManager

    @StateObject var homeViewModel: HomeViewModel

    init() {
        // Dependency tree
        let repository = CaseStatusRepository()
        self.repository = repository

        self._homeViewModel = StateObject(wrappedValue: HomeViewModel(repository: repository))

        self.notificationService = NotificationService()

        self.backgroundRefreshManager = BackgroundRefeshManager()
        backgroundRefreshManager.delegate = self

        // Schedule background refresh
        backgroundRefreshManager.schedule()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}

extension CaseTrackerApp: BackgroundRefreshableDelegate {
    func refresh() async {
        await repository.query(force: false)
    }
}
