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

public struct CaseStatus: Codable, Identifiable {

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

    public let receiptNumber: String
    public var status: String
    public var body: String
    public var formType: String?
    public var lastUpdated: Date?
    public var lastFetched: Date?

    public init(receiptNumber: String, status: String, body: String, formType: String?, lastUpdated: Date?, lastFetched: Date?) {
        self.receiptNumber = receiptNumber
        self.status = status
        self.body = body
        self.formType = formType
        self.lastUpdated = lastUpdated
        self.lastFetched = lastFetched
    }

    public var id: String {
        receiptNumber
    }

    public var color: Color {
        return Status(rawValue: status)?.color ?? .blue
    }

    public var lastUpdatedFormatted: String {
        if let lastUpdated = lastUpdated {
            return CaseStatus.dateFormatter.string(from: lastUpdated)
        }
        return ""
    }

    public var lastUpdatedRelativeFormatted: String {
        if let lastUpdated = lastUpdated {
            return CaseStatus.relativeDateFormatter.localizedString(for: lastUpdated, relativeTo: .now)
        }
        return ""
    }

    public var lastUpdatedRelativeDaysFormatted: String {
        if let lastUpdated = lastUpdated,
           let day = Calendar(identifier: .gregorian).dateComponents([.day], from: lastUpdated, to: .now).day {
            switch day {
            case 0:
                return "Today"
            case 1:
                return "1 day ago"
            default:
                return "\(day) days ago"
            }
        }
        return ""
    }
}

extension CaseStatus: CustomStringConvertible {
    public var description: String {
        "CaseStatus(\(id), \(formType ?? "--"), \(status), "
        + "lastUpdated: \(String(describing: lastUpdated)), dateFetched: \(String(describing: lastFetched)))"
    }
}

extension CaseStatus {
    init(receiptNumber: String, htmlString: String) throws {
        defer { os_signpost(.end, log: OSLog.caseTrackerPoi, name: "CaseStatus_init") }
        os_signpost(.begin, log: OSLog.caseTrackerPoi, name: "CaseStatus_init")

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
