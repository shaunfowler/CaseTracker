//
//  DetailsViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/22/22.
//

import Foundation
import Combine

class DetailsViewModel: ObservableObject {

    @Published var isPresentingActionSheet = false
    @Published var isPresentingDeleteConfirmation = false
    @Published var isShowingActivityViewController = false
    @Published var isPresentingWebView = false
    @Published var history = [CaseStatusHistorical]()

    var isHistoryAvailable: Bool {
        featureService.isEnabled(feature: .history) && !history.isEmpty
    }

    private let repository: Repository
    private let featureService: FeatureServiceProtocol

    init(repository: Repository, featureService: FeatureServiceProtocol = FeatureService.shared) {
        self.repository = repository
        self.featureService = featureService
    }

    func load(receiptNumber: String) async {
        history = (try? await repository.getHistory(receiptNumber: receiptNumber).get()) ?? []
    }
}
