//
//  MockLocalCaseStatusAPI.swift
//  CaseTrackerTests
//
//  Created by Shaun Fowler on 4/5/22.
//

import Foundation
@testable import CaseTracker

class MockLocalCaseStatusAPI: CaseStatusQueryable, CaseStatusWritable {

    var onSetCalled: ((CaseStatus) -> Result<CaseStatus, Error>)?
    func set(caseStatus: CaseStatus) async -> Result<CaseStatus, Error> {
        onSetCalled?(caseStatus) ?? .success(caseStatus)
    }

    var onRemoveCalled: ((String) -> Result<(), Error>)?
    func remove(receiptNumber: String) async -> Result<(), Error> {
        onRemoveCalled?(receiptNumber) ?? .success(())
    }

    var onQueryCalled: (() -> Result<[CaseStatus], Error>)?
    func query() async -> Result<[CaseStatus], Error> {
        onQueryCalled?() ?? .success([])
    }

    var onHistoryCalled: ((String) -> Result<[CaseStatusHistorical], Error>)?
    func history(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error> {
        onHistoryCalled?(receiptNumber) ?? .success([])
    }
}
