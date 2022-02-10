//
//  Utils.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import Foundation

func extractDate(body: String) -> Date? {
    guard let range = body.range(
        of: #"(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+\d{4}"#,
        options: .regularExpression
    ) else {
        return nil
    }

    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM d, yyyy"
    return formatter.date(from: String(body[range]))
}


func extractFormType(body: String) -> String? {
    guard let range = body.range(
        of: #"(I-|N-)\d{2,4}\w{0,2}"#,
        options: .regularExpression
    ) else {
        return nil
    }
    return String(body[range])
}
