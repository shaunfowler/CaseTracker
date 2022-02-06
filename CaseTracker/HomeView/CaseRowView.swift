//
//  CaseRowView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct CaseRowView: View {

    let model: CaseStatus

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 4)
                .frame(width: 4)
                .foregroundColor(model.color)
                .padding(8)
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    if let formType = model.formType {
                        Text(formType)
                            .fontWeight(.bold)
                    }
                    Text(model.id)
                        .fontWeight(.semibold)
                }

                Text(model.status)

                HStack {
                    if !model.lastUpdatedFormatted.isEmpty {
                        Text(model.lastUpdatedFormatted)
                            .opacity(0.5)
                    }
                    Spacer()
                    if !model.lastUpdatedRelativeFormatted.isEmpty {
                        Text(model.lastUpdatedRelativeFormatted)
                            .opacity(0.5)
                    }
                }

                // Text(model.dateFetched.description)
            }
            .padding([.leading], 0)
            .padding([.trailing, .top, .bottom], 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("CaseRowBackgroundColor"))
        .cornerRadius(8)
        .shadow(color: Color("CaseRowShadowColor"), radius: 4)
    }
}

struct CaseRowView_Previews: PreviewProvider {
    static var previews: some View {
        CaseRowView(
            model: CaseStatus(
                id: "MSC1234567890",
                status: "Case Was Updated To Show Fingerprints Were Taken",
                body: "",
                formType: "I-765",
                lastUpdated: Date(),
                dateFetched: Date()))
            .previewLayout(.sizeThatFits)
    }
}
