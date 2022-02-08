//
//  HomeViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {

    private enum Constants {
        static let refreshInterval: TimeInterval = 10 * 60 // 10-min
    }

    private var cancellables = Set<AnyCancellable>()
    private let repository: Repository

    @Published var phase: ScenePhase?
    @Published var cases = [CaseStatus]()
    @Published var selectedCase: CaseStatus?
    @Published var loading = true
    @Published var errorMessage: String?
    @Published var isAddCaseViewPresented = false
    @Published var isDetailsViewPresented = false

    var lastFetch: Date? {
        cases
            .compactMap { $0.dateFetched }
            .sorted { lhs, rhs in lhs < rhs }
            .first // earliest date
    }

    init(repository: Repository = CaseStatusRepository()) {
        self.repository = repository

        // TODO: Move to repository and use bind to AnyPublisher in view model
        Timer.scheduledTimer(withTimeInterval: Constants.refreshInterval, repeats: true) { _ in
            Task { [weak self] in
                guard let self = self, self.phase == .active else {
                    print("Skipping reload, scene phase:", self?.phase as Any)
                    return
                }
                print("Reloading data on periodic timer...")
                await self.fetch()
            }
        }

        $phase
            .compactMap { $0 }
            .print("Phase publisher")
            .sink {
                if $0 == .active {
                    Task { await self.fetch() }
                }
            }
            .store(in: &cancellables)
    }

    func fetch(force: Bool = false) async {
        // Get from cache or remote API if cache is expired.
        loading = true
        do {
            cases = try await repository.query(force: force).get()
        } catch {
            errorMessage = error.localizedDescription
        }
        loading = false
    }

    func removeCase(atIndex index: Int) {
        let receiptNumber = cases[index].id
        cases = cases.filter { $0.id != receiptNumber }
        Task {
            let _ = await repository.removeCase(receiptNumber: receiptNumber)
        }
    }
}

extension CaseStatus {

    static var relativeFormatter: RelativeDateTimeFormatter {
        let formatter = RelativeDateTimeFormatter()
        formatter.formattingContext = .standalone
        return formatter
    }

    var relativeDateFormatted: String {
        CaseStatus.relativeFormatter.string(for: dateFetched) ?? dateFetched.formatted()
    }
}
