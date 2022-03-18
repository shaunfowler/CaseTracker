//
//  CaseRowView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI
import CaseTrackerCore

struct CaseRowView: View {

    @ScaledMetric var fontSize: CGFloat = 14

    let model: CaseStatus

    var body: some View {
        HStack(spacing: 0) {

            RoundedRectangle(cornerRadius: 4)
                .frame(width: 4)
                .foregroundColor(model.color)
                .padding(10)

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
                    HStack {
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
            .padding([.leading], 0)
            .padding([.top, .bottom], 10)
        }
    }
}

struct CaseRowView_Previews: PreviewProvider {

    static var model1: CaseStatus {
        var model = PreviewDataRepository.case1
        model.lastUpdated = Date().advanced(by: -(60 * 60 * 24 * 60))
        return model
    }

    static var model2: CaseStatus {
        var model = PreviewDataRepository.case2
        model.lastUpdated = Date().advanced(by: -(60 * 60 * 24 * 1))
        return model
    }

    static var model3: CaseStatus {
        var model = PreviewDataRepository.case3
        model.lastUpdated = Date.now
        return model
    }

    static var previews: some View {
        Group {
            VStack(alignment: .leading) {
                CaseRowView(model: model1)
                CaseRowView(model: model2)
                CaseRowView(model: model3)
            }
            .preferredColorScheme(.light)

            VStack(alignment: .leading) {
                CaseRowView(model: model1)
                CaseRowView(model: model2)
                CaseRowView(model: model3)
            }
            .preferredColorScheme(.dark)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
