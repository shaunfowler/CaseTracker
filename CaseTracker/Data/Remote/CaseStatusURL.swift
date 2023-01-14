//
//  CaseStatusURL.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation

enum CaseStatusURL {

    private static let baseUrl = URL(string: "https://egov.uscis.gov/casestatus/mycasestatus.do")!
    
    private static func buildRequestPayload(receiptNumber: String) -> String {
        "[\"appReceiptNum\": \"\(receiptNumber)\"]"
    }

    case post(String)

    var request: URLRequest {
        switch self {
        case .post(let receiptNumber):
            var request = URLRequest(url: Self.baseUrl)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            var urlComponents = URLComponents()
            urlComponents.queryItems = [.init(name: "appReceiptNum", value: receiptNumber)]
            request.httpBody = urlComponents.query?.data(using: .utf8)
            return request
        }
    }
}
