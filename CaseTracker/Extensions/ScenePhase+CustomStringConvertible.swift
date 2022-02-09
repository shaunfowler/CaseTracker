//
//  ScenePhase+CustomStringConvertible.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import SwiftUI

extension ScenePhase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .background:
            return "background"
        case .inactive:
            return "inactive"
        case .active:
            return "active"
        @unknown default:
            return "unknown"
        }
    }
}
