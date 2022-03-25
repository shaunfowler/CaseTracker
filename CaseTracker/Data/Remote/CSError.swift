//
//  CSError.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation

public enum CSError: Error {
    case corrupt(String)
    case decoding(String)
    case http(String, Int?)
    case htmlParse(String)
    case notCached(String)
    case invalidCase(String)

    var receiptNumber: String {
        switch self {
        case .corrupt(let receiptNumber):
            return receiptNumber
        case .decoding(let receiptNumber):
            return receiptNumber
        case .http(let receiptNumber, _):
            return receiptNumber
        case .htmlParse(let receiptNumber):
            return receiptNumber
        case .notCached(let receiptNumber):
            return receiptNumber
        case .invalidCase(let receiptNumber):
            return receiptNumber
        }
    }
}

extension CSError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .corrupt(let receiptNumber):
            return "corrupt{\(receiptNumber)}"
        case .decoding(let receiptNumber):
            return "decoding{\(receiptNumber)}"
        case .http(let receiptNumber, let statusCode):
            return "http{\(receiptNumber),\(statusCode ?? 0)}"
        case .htmlParse(let receiptNumber):
            return "htmlParse{\(receiptNumber)}"
        case .notCached(let receiptNumber):
            return "notCached{\(receiptNumber)}"
        case .invalidCase(let receiptNumber):
            return "invalidCase{\(receiptNumber)}"
        }
    }
}

extension CSError: LocalizedError {

    public var errorDescription: String? {
        "Failed to fetch case \(receiptNumber) status from USCIS."
    }
}
