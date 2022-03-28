//
//  Protocols.swift
//  CaseTrackerCore
//
//  Created by Fowler, Shaun on 2/20/22.
//

import Foundation

protocol CaseStatusReadable {
    func get(forCaseId id: String) async -> Result<CaseStatus, Error>
}

protocol CaseStatusQueryable {
    func query() async -> Result<[CaseStatus], Error>
    func history(receiptNumber: String) async -> Result<[CaseStatusHistorical], Error>
}

protocol CaseStatusWritable {
    @discardableResult
    func set(caseStatus: CaseStatus) async -> Result<(), Error>
    func remove(receiptNumber: String) async -> Result<(), Error>
}
