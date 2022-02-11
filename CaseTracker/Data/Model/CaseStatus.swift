//
//  CaseStatus.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftUI
import SwiftSoup
import OSLog

struct CaseStatus: Codable, Identifiable {

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let relativeDateFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    let receiptNumber: String
    var status: String
    var body: String
    var formType: String?
    var lastUpdated: Date?
    var lastFetched: Date?

    var id: String {
        receiptNumber
    }

    var color: Color {
        return Status(rawValue: status)?.color ?? .blue
    }

    var lastUpdatedFormatted: String {
        if let lastUpdated = lastUpdated {
            return CaseStatus.dateFormatter.string(from: lastUpdated)
        }
        return ""
    }

    var lastUpdatedRelativeFormatted: String {
        if let lastUpdated = lastUpdated {
            return CaseStatus.relativeDateFormatter.localizedString(for: lastUpdated, relativeTo: .now)
        }
        return ""
    }
}

extension CaseStatus: CustomStringConvertible {
    var description: String {
        "CaseStatus(\(id), \(formType ?? "--"), \(status), "
        + "lastUpdated: \(String(describing: lastUpdated)), dateFetched: \(String(describing: lastFetched)))"
    }
}

extension CaseStatus {
    init(receiptNumber: String, htmlString: String) throws {
        let doc: Document = try SwiftSoup.parse(htmlString)

        guard
            let status = try doc.select(".rows.text-center h1").first?.text(),
            let body = try doc.select(".rows.text-center p").first?.text() else {
                throw CSError.htmlParse
            }

        if let error = try? doc.select("#formErrorMessages").first?.text(), !error.isEmpty {
            Logger.api.error("Error message found on webpage: \(error, privacy: .public).")
            throw CSError.invalidCase
        }

        self.receiptNumber = receiptNumber
        self.status = status
        self.body = body
        self.lastUpdated = extractDate(body: body)
        self.formType = extractFormType(body: body)

        self.lastFetched = Date.now - 1
    }
}
