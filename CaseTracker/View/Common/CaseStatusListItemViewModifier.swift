//
//  CaseStatusListItemViewModifier.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/9/22.
//

import SwiftUI

struct CaseStatusListItemViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.trailing, 8)
            .background(Color("CaseRowBackgroundColor"))
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .padding([.top, .bottom], 0)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

struct CaseStatusListItemViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("I'm a list item.")
            .modifier(CaseStatusListItemViewModifier())
    }
}
