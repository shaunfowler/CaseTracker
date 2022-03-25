//
//  HomeViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftUI
import Combine
import CocoaLumberjack

@MainActor
class HomeViewModel: ObservableObject {

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()
    private let repository: Repository
    private var isNetworkReachable = true

    // MARK: - Public Properties

    @Published var cases = [CaseStatus]()

    @Published var selectedCase: CaseStatus?
    @Published var loading = true
    @Published var errorMessage: String?

    @Published var isAddCaseViewPresented = false
    @Published var isDetailsViewPresented = false
    @Published var isNetworkMessagePresented = false

    var lastFetch: Date? {
        cases
            .compactMap { $0.lastFetched }
            .sorted { lhs, rhs in lhs < rhs }
            .first // earliest date
    }

    var lastUpdatedLoadingMessage: String {
        // Always show loading if request is pending.
        if loading {
            return "Refreshing cases..."
        }

        // Loaded date only if there are cases.
        if let lastFetch = lastFetch, !cases.isEmpty {
            return "Last updated at \(lastFetch.formatted())."
        }

        return ""
    }

    var isEmptyState: Bool {
        !loading && cases.isEmpty
    }

    var addCaseViewModel: AddCaseViewModel {
        AddCaseViewModel(repository: repository)
    }

    // MARK: - Initialization

    init(repository: Repository) {
        self.repository = repository

        repository
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.cases = value
            }
            .store(in: &cancellables)

        // cases = PreviewDataRepository().cases

        repository
            .error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.errorMessage = value?.localizedDescription
            }
            .store(in: &cancellables)

        repository
            .networkReachable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isNetworkReachable = value
            }
            .store(in: &cancellables)

        NotificationCenter
            .default
            .publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                DDLogInfo("Entering foreground.")
                Task { [weak self] in
                    await self?.fetch()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Functions

    func refresh() async {
        guard isNetworkReachable else {
            isNetworkMessagePresented = true
            return
        }
        await fetch(force: true)
    }

    func fetch(force: Bool = false) async {
        // Get from cache or remote API if cache is expired.
        loading = true
        await repository.query(force: force)
        loading = false
    }

    func removeCase(atIndex index: Int) {
        let receiptNumber = cases[index].id
        removeCase(receiptNumber: receiptNumber)
    }

    func removeCase(receiptNumber: String) {
        cases = cases.filter { $0.id != receiptNumber }
        Task {
            await repository.removeCase(receiptNumber: receiptNumber)
        }
    }

    func createDetailsViewModel() -> DetailsViewModel {
        DetailsViewModel(repository: repository)
    }
}

extension CaseStatus {

    static var relativeFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = .standalone
        return formatter
    }
}
