//
//  Protocols.swift
//  CaseTrackerCore
//
//  Created by Fowler, Shaun on 2/20/22.
//

import Foundation

public protocol CaseStatusReadable {
    func get(forCaseId id: String) async -> Result<CaseStatus, Error>
}

public protocol CaseStatusQueryable {
    func query() async -> Result<[CaseStatus], Error>
    func history(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error>
}

public protocol CaseStatusWritable {
    @discardableResult
    func set(caseStatus: CaseStatus) async -> Result<(), Error>
    func remove(receiptNumber: String) async -> Result<(), Error>
}
