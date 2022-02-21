//
//  Color.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/14/22.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    public static let ctBackground = Color("HomeBackgroundColor")
    public static let ctRowBackground = Color("CaseRowBackgroundColor")
    public static let ctRowShadow = Color("CaseRowShadowColor")

    public static let ctGreen = Color("CTGreen")
    public static let ctRed = Color("CTRed")
    public static let ctYellow = Color("CTYellow")
    public static let ctOrange = Color("CTOrange")
    public static let ctGray = Color("CTGray")
    public static let ctBlue = Color("CTBlue")
}

extension UIColor {
    public static let ctBackground = UIColor(named: "HomeBackgroundColor")
    public static let ctRowBackground = UIColor(named: "CaseRowBackgroundColor")
    public static let ctRowShadow = UIColor(named: "CaseRowShadowColor")

    public static let ctGreen = UIColor(named: "CTGreen")
    public static let ctRed = UIColor(named: "CTRed")
    public static let ctYellow = UIColor(named: "CTYellow")
    public static let ctOrange = UIColor(named: "CTOrange")
    public static let ctGray = UIColor(named: "CTGray")
    public static let ctBlue = UIColor(named: "CTBlue")
}
