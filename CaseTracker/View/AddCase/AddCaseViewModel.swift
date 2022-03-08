//
//  AddCaseViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import Foundation
import CocoaLumberjack
import CaseTrackerCore

@MainActor
class AddCaseViewModel: ObservableObject {

    private let repository: Repository

    @Published var receiptNumber: String = ""
    @Published var showError = false
    @Published var isLoading = false

    init(repository: Repository) {
        self.repository = repository
    }

    func attemptAddCase() async {
        isLoading = true
        let receiptNumber = receiptNumber
        DDLogInfo("Attempting to add case: \(receiptNumber).")
        let result = await repository.addCase(receiptNumber: receiptNumber)
        switch result {
        case .failure(let error):
            DDLogInfo("Error adding case: \(receiptNumber) with error: \(error.localizedDescription)." )
            showError = true
        case .success(let caseStatus):
            DDLogInfo("Added case: \(caseStatus).")
        }
        isLoading = false
    }
}
