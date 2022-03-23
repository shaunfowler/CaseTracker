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

    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func load(receiptNumber: String) async {
        history = (try? await repository.getHistory(receiptNumber: receiptNumber).get()) ?? []
    }
}
