//
//  CaseStatusListItemViewModifier.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import SwiftUI

private struct CaseStatusListItemViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.trailing, 8)
            .background(Color.ctRowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding([.top, .bottom], 0)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

extension NavigationLink {
    func caseStatusListItemStyle() -> some View {
        modifier(CaseStatusListItemViewModifier())
    }
}

struct CaseStatusListItemViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationLink("I'm a list item.") { }
            .caseStatusListItemStyle()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
