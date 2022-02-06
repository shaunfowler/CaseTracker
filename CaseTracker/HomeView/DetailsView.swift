//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct DetailsView: View {

    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL

    let text: String
    let id: String

    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Text("Close")
                        .font(.system(size: 18))
                }
            }

            Spacer()

            Text(text)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .serif))

            Spacer()

            Button("View on USCIS Website") {
                openURL(CaseStatusURL.get(id).url)
            }
            .buttonStyle(.borderedProminent)

            Spacer()

        }
        .padding()
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(text: "Hello", id: "abc1234")
    }
}
