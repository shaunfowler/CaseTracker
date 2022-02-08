//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct DetailsView: View {

    @Environment(\.openURL) var openURL

    let text: String
    let id: String

    var body: some View {
        ScrollView {
            VStack {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.system(.body, design: .serif))
                    .padding()

                Button("View on USCIS Website") {
                    openURL(CaseStatusURL.get(id).url)
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(id)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(text: "Hello", id: "abc1234")
    }
}
