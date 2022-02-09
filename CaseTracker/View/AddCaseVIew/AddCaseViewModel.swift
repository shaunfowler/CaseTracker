//
//  AddCaseViewModel.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import Foundation

@MainActor
class AddCaseViewModel: ObservableObject {

    private let repository = CaseStatusRepository()

    @Published var receiptNumber: String = ""
    @Published var showError = false

    func attemptAddCase() async {
        print("Attempting to add case", receiptNumber)
        let result = await repository.addCase(receiptNumber: receiptNumber)

        switch result {
        case .failure(let error):
            print("Error adding case", receiptNumber, error.localizedDescription)
            showError = true
        case .success(let caseStatus):
            print("Added case", caseStatus)
        }
    }
}
