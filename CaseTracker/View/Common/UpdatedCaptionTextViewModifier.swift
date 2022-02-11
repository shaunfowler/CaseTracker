//
//  UpdatedCaptionTextViewModifier.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import Foundation
import SwiftUI

private struct UpdatedCaptionTextViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .opacity(0.3)
            .frame(maxWidth: .infinity, alignment: .center)
            .listSectionSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

extension View {
    func updatedCaptionTextStyle() -> some View {
        modifier(UpdatedCaptionTextViewModifier())
    }
}

struct UpdatedCaptionTextViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Text("Some Text")
                .updatedCaptionTextStyle()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
