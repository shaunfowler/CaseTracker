//
//  CaseStatusHistorical.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/22/22.
//

import Foundation
import SwiftUI

struct CaseStatusHistorical {
    let receiptNumber: String
    let dateAdded: Date
    let lastUpdated: Date?
    let status: String
}

extension CaseStatusHistorical {

    var color: Color {
        return Status(rawValue: status)?.color ?? .blue
    }

    var lastUpdatedFormatted: String? {
        guard let lastUpdated = lastUpdated else { return nil }
        return CaseStatus.dateFormatter.string(from: lastUpdated)
    }
}
