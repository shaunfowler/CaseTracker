//
//  CaseStatusHistorical.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/22/22.
//

import Foundation
import SwiftUI

public struct CaseStatusHistorical {
    let receiptNumber: String
    let date: Date
    let status: String
}

extension CaseStatusHistorical {

    var color: Color {
        return Status(rawValue: status)?.color ?? .blue
    }

    var lastUpdatedFormatted: String {
        CaseStatus.dateFormatter.string(from: date)
    }
}
