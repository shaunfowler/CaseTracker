//
//  MetricOperational.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/25/22.
//

import Foundation
import FirebaseAnalytics

enum MetricOperationalCount: String {

    case caseCount = "Case Count"
    case historyCount = "History Count"

    func send(count: Int) {
        Analytics.logEvent("operational_count", parameters: [
            "ct_component": self.rawValue,
            "ct_count": count
        ])
    }
}
