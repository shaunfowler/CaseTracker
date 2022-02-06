//
//  CaseStatus.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftUI
import SwiftSoup

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

    let id: String
    var status: String
    var body: String
    var formType: String?
    var lastUpdated: Date?
    var dateFetched: Date

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
        + "lastUpdated: \(String(describing: lastUpdated)), dateFetched: \(dateFetched))"
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
            print(error)
            throw CSError.invalidCase
        }

        self.id = receiptNumber
        self.status = status
        self.body = body
        self.lastUpdated = extractDate(body: body)
        self.formType = extractFormType(body: body)

        self.dateFetched = Date.now - 1
    }
}
