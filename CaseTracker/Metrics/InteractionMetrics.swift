//
//  InteractionMetrics.swift
//  CaseTrackerCore
//
//  Created by Shaun Fowler on 3/16/22.
//

import Foundation
import FirebaseAnalytics

public enum InteractionMetric: String {

    // Home
    case tapAddNavBarButton
    case tapAddFirstTimeButton
    case swipeDeleteCase
    case pullToRefreshCaseList

    // Add case
    case tapAddCaseSubmitModalButton
    case tabCloseAddCaseModalButton

    // Case details
    case tapShareNavBarButton
    case tapMoreNavBarButton
    case tapCopyReceiptNumberMenuButton
    case tapRequestRemoveCaseMenuButton
    case tapRemoveCaseConfirmAlertButton
    case tapViewOnWebsiteButton

    // View impressions
    case viewHome
    case viewAddCase
    case viewCaseDetails
    case viewWebsite
    case viewAddCaseErrorAlert // ?

    public func send() {
        // AnalyticsEventSelectContent
        // AnalyticsEventViewItem

        let eventType: String
        switch self {
        case .viewHome, .viewAddCase, .viewCaseDetails, .viewWebsite, .viewAddCaseErrorAlert:
            eventType = AnalyticsEventViewItem
        default:
            eventType = AnalyticsEventSelectContent
        }

        Analytics.logEvent(eventType, parameters: [
            AnalyticsParameterItemID: self.rawValue,
            AnalyticsParameterItemName: self.rawValue
        ])
    }
}
