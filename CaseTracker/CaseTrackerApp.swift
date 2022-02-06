//
//  CaseTrackerApp.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/30/22.
//

import SwiftUI
import SwiftSoup

@main
struct CaseTrackerApp: App {

    @StateObject var homeViewModel = HomeViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
