//
//  CaseRowView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct CaseRowView: View {

    @ScaledMetric var fontSize: CGFloat = 14

    let model: CaseStatus

    var body: some View {
        HStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 4)
                .frame(width: 4)
                .foregroundColor(model.color)
                .padding(10)

            VStack(alignment: .leading, spacing: 8) {

                HStack(alignment: .center, spacing: 8) {
                    if let formType = model.formType {
                        Text(formType)
                            .fontWeight(.bold)
                    }
                    Text(model.id)
                }

                Text(model.status)
                    .font(.system(size: fontSize))

                HStack {
                    if !model.lastUpdatedFormatted.isEmpty {
                        Text(model.lastUpdatedFormatted)
                            .font(.system(size: fontSize))
                            .opacity(0.5)
                    }
                    Spacer()
                    if !model.lastUpdatedRelativeFormatted.isEmpty {
                        Text(model.lastUpdatedRelativeFormatted)
                            .font(.system(size: fontSize))
                            .opacity(0.5)
                    }
                }
            }
            .padding([.leading], 0)
            .padding([.trailing, .top, .bottom], 8)
        }
    }
}

struct CaseRowView_Previews: PreviewProvider {
    static var previews: some View {
        CaseRowView(
            model: CaseStatus(
                receiptNumber: "MSC1234567890",
                status: "Case Was Updated To Show Fingerprints Were Taken",
                body: "",
                formType: "I-765",
                lastUpdated: Date(),
                lastFetched: Date()))
            .previewLayout(.sizeThatFits)
    }
}
