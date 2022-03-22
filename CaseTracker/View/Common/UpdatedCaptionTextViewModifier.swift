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
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .center)
            .listStyle(.plain)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .textCase(.none)
            .padding(.bottom, 4)
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
