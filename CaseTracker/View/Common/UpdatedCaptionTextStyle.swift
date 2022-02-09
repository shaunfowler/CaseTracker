//
//  UpdatedCaptionTextStyle.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import SwiftUI

struct UpdatedCaptionTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .opacity(0.3)
            .frame(maxWidth: .infinity, alignment: .center)
            .listSectionSeparator(.hidden)
    }
}
