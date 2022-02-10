//
//  CaseStatusAPI.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 1/31/22.
//

import Foundation
import SwiftSoup

enum CSError: Error {
    case corrupt
    case decoding
    case http
    case htmlParse
    case notCached
    case invalidCase
}

