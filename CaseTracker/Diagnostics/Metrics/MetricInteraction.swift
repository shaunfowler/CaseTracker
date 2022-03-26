//
//  InteractionMetrics.swift
//  CaseTrackerCore
//
//  Created by Shaun Fowler on 3/16/22.
//

import Foundation
import FirebaseAnalytics

public enum MetricInteraction: String {

    // Home
    case tapAddNavBarButton = "Case List - Add Button (Nav)"
    case tapAddFirstTimeButton = "Case List - Add Button (FTUE)"
    case swipeDeleteCase = "Case List - Delete Swipe"
    case pullToRefreshCaseList = "Case List - Refresh"

    // Add case
    case tapAddCaseSubmitModalButton = "Add Case - Submit"
    case tapCloseAddCaseModalButton = "Add Case - Close"

    // Case details
    case tapShareNavBarButton = "Details - Share"
    case tapMoreNavBarButton = "Details - More Menu"
    case tapCopyReceiptNumberMenuButton = "Details - Copy Receipt Number"
    case tapRequestRemoveCaseMenuButton = "Details - Remove Request"
    case tapRemoveCaseConfirmAlertButton = "Details - Remove Confirm"
    case tapViewOnWebsiteButton = "Details - View On Website"

    public func send() {
        Analytics.logEvent("interaction", parameters: [
            AnalyticsParameterItemName: self.rawValue
        ])
    }
}

public enum MetricScreenView: String {

    case viewHome = "Case List"
    case viewAddCase = "Add Case"
    case viewCaseDetails = "Case Details"
    case viewWebsite = "Website"

    public func send() {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: self.rawValue
        ])
    }

    public func send(receiptNumber: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterItemName: self.rawValue,
            "ct_receipt_number": receiptNumber
        ])
    }
}
