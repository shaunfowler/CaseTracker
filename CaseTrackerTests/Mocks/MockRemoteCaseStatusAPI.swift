//
//  MockRemoteCaseStatusAPI.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 4/5/22.
//

import Foundation
@testable import Case_Tracker

class MockRemoteCaseStatusAPI: CaseStatusReadable {

    var onGetCalled: ((String) -> Result<CaseStatus, Error>)?

    func get(forCaseId id: String) async -> Result<CaseStatus, Error> {
        onGetCalled?(id) ?? .failure(CSError.invalidCase(id))
    }
}
