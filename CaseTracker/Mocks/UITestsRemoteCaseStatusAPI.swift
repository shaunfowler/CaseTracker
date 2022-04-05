//
//  UITestsRemoteCaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/18/22.
//

import Foundation

/// Mock for UITests.
class UITestsRemoteCaseStatusAPI: CaseStatusReadable {

    private var cases: [String: CaseStatus] = [
        PreviewDataRepository.case1.id: PreviewDataRepository.case1,
        PreviewDataRepository.case2.id: PreviewDataRepository.case2,
        PreviewDataRepository.case3.id: PreviewDataRepository.case3,
        PreviewDataRepository.case4.id: PreviewDataRepository.case4
    ]

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        guard let caseStatus = cases[id] else {
            return .failure(CSError.invalidCase(id))
        }
        return .success(caseStatus)
    }
}
