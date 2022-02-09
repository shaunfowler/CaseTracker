//
//  FirstTimeUserView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import SwiftUI

struct FirstTimeUserView: View {

    let onAddCase: () -> Void

    var body: some View {
        VStack(spacing: 64) {
            Text("No cases have been added")
                .font(.headline)
                .opacity(0.5)

            PrimaryButton(title: "Add Your First Case") {
                onAddCase()
            }
        }
    }
}

struct FirstTimeUserView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTimeUserView { }
    }
}
