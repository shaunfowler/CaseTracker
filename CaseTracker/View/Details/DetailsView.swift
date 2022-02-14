//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct DetailsView: View {

    @Environment(\.openURL) var openURL

    let caseStatus: CaseStatus

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                if let formType = caseStatus.formType {
                    Text("Form \(formType)")
                        .font(.headline)
                }

                HStack(alignment: .firstTextBaseline) {
                    Circle()
                        .foregroundColor(caseStatus.color)
                        .frame(width: 8, height: 8, alignment: .center)
                        .offset(y: -2)
                    Text(caseStatus.status)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text(caseStatus.body)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .serif))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("CaseRowBackgroundColor"))
                .cornerRadius(4)

            Spacer()

            Button("View on USCIS Website") {
                openURL(CaseStatusURL.get(caseStatus.receiptNumber).url)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 24)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color("HomeBackgroundColor"))
        .navigationBarTitle(caseStatus.receiptNumber)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(caseStatus: PreviewDataRepository.case1)
    }
}
