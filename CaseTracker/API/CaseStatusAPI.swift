//
//  CaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftSoup

enum CSError: Error {
    case corrupt
    case decoding
    case http
    case htmlParse
    case notCached
    case invalidCase
}

protocol CaseStatusReadable {
    func get(forCaseId id: String) async -> Result<CaseStatus, Error>
}

protocol CaseStatusCachable {
    func keys() -> [String]
}

protocol CaseStatusWritable {
    @discardableResult
    func set(caseStatus: CaseStatus) async -> Result<(), Error>
    func remove(receiptNumber: String) async -> Result<(), Error>
}
