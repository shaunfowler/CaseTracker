//
//  Color.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/14/22.
//

import Foundation
import SwiftUI

extension Color {
    static let ctBackgroundPrimary = Color("BackgroundPrimary")
    static let ctBackgroundSecondary = Color("BackgroundSecondary")

    static let ctTextPrimary = Color("TextPrimary")
    static let ctTextSecondary = Color("TextSecondary")
    static let ctTextTertiary = Color("TextTertiary")

    static let ctShadow = Color("Shadow")
}

extension UIColor {
    static let ctBackgroundPrimary = UIColor(Color.ctBackgroundPrimary)
    static let ctBackgroundSecondary = UIColor(Color.ctBackgroundSecondary)

    static let ctTextPrimary = UIColor(Color.ctTextPrimary)
    static let ctTextSecondary = UIColor(Color.ctTextSecondary)
    static let ctTextTertiary = UIColor(Color.ctTextTertiary)

    static let ctShadow = UIColor(Color.ctShadow)
}
