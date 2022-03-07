//
//  OSLog+signpost.swift
//  CaseTrackerCore
//
//  Created by Shaun Fowler on 3/6/22.
//

import Foundation
import OSLog

extension OSLog {

    static let caseTrackerPoi = OSLog(subsystem: "com.shaunfowler.CaseTracker",
                                      category: .pointsOfInterest)
}
