//
//  CaseRowView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/28/22.
//

import SwiftUI

struct CaseRowView: View {

    @ScaledMetric var fontSize: CGFloat = 14

    var model: CaseStatus

    var body: some View {
        HStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 4)
                .frame(width: 4)
                .foregroundColor(model.color)
                .padding(.trailing, 8)
                .padding([.top, .bottom], 2)

            VStack(alignment: .leading, spacing: 4) {

                HStack(alignment: .center, spacing: 8) {
                    if let formType = model.formType {
                        Text(formType)
                            .fontWeight(.bold)
                            .foregroundColor(.ctTextPrimary)
                    }
                    Text(model.id)
                        .foregroundColor(.ctTextPrimary)
                }

                Text(model.status)
                    .font(.system(size: fontSize))
                    .foregroundColor(.ctTextSecondary)

                if !model.lastUpdatedFormatted.isEmpty {
                    HStack(spacing: 4) {
                        Text(model.lastUpdatedFormatted)
                        if !model.lastUpdatedRelativeDaysFormatted.isEmpty {
                            Text("•")
                            Text(model.lastUpdatedRelativeDaysFormatted)
                        }
                    }
                    .font(.system(size: fontSize))
                    .foregroundColor(.ctTextTertiary)
                }
            }

            Spacer()
        }
        .background(Color.ctBackgroundSecondary.opacity(0.01)) // Increase touch area
        .padding(8)
    }
}

struct CaseRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            CaseRowView(model: PreviewDataRepository.case1)
                .padding()
            CaseRowView(model: PreviewDataRepository.case2)
                .padding()
        }
        .background(Color.ctBackgroundPrimary)
        .previewLayout(.sizeThatFits)
    }
}
