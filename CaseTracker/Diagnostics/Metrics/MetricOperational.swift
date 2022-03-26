//
//  MetricOperational.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/25/22.
//

import Foundation
import FirebaseAnalytics

public enum MetricOperationalCount: String {

    case caseCount = "Case Count"
    case historyCount = "History Count"

    public func send(count: Int) {
        Analytics.logEvent("operational_count", parameters: [
            "ct_count": count
        ])
    }
}
