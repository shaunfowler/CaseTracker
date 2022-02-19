//
//  CaseStatusListItemViewModifier.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import SwiftUI

private struct CaseStatusListItemViewModifier: ViewModifier {

    var shadowColor = Color.ctRowShadow

    func body(content: Content) -> some View {
        content
            .padding(.trailing, 8)
            .background(Color.ctRowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding([.top, .bottom], 2)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .shadow(color: shadowColor, radius: 16, x: 0, y: 0)
    }
}

extension NavigationLink {
    func caseStatusListItemStyle(shadowColor: Color = .ctRowShadow) -> some View {
        modifier(CaseStatusListItemViewModifier(shadowColor: shadowColor))
    }
}

struct CaseStatusListItemViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationLink("I'm a list item.") { }
            .caseStatusListItemStyle()
            NavigationLink("I'm a list item.") { }
            .caseStatusListItemStyle(shadowColor: .red.opacity(0.5))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
