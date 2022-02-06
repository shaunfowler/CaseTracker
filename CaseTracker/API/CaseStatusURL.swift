//
//  CaseStatusURL.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation

enum CaseStatusURL {

    private static let baseUrl = URL(string: "https://egov.uscis.gov/casestatus/mycasestatus.do?")!

    private static func buildUrl(receiptNumber: String) -> URL {
        // language=ENGLISH&caseStatusSearch=caseStatusPage&appReceiptNum=XXX
        var urlComponents = URLComponents(string: "https://egov.uscis.gov/casestatus/mycasestatus.do")!
        let queryItems = [
            URLQueryItem(name: "language", value: "ENGLISH"),
            URLQueryItem(name: "caseStatusSearch", value: "caseStatusPage"),
            URLQueryItem(name: "appReceiptNum", value: receiptNumber),
        ]
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }

    case get(String)

    var url: URL {
        switch self {
        case .get(let receiptNumber):
            return Self.buildUrl(receiptNumber: receiptNumber)
        }
    }
}
