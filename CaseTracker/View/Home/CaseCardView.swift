//
//  CaseCardView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/28/22.
//

import SwiftUI

struct CaseCardView: View {

    @ScaledMetric var statusFontSize: CGFloat = 14
    @ScaledMetric var dateFontSize: CGFloat = 13
    @ScaledMetric var orbSize: Double = 10

    var model: CaseStatus

    @ViewBuilder var formSection: some View {
        if let formType = model.formType {
            VStack(alignment: .leading) {
                Group {
                    Text(formType)
                        .font(.headline) +
                    Text("  \(model.receiptNumber)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.ctTextSecondary)

                if let formName = model.formName {
                    Text(formName)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.caption2)
                        .foregroundColor(.ctTextTertiary.opacity(0.8))
                }
            }
        } else {
            Text(model.receiptNumber)
                .font(.headline)
                .foregroundColor(.ctTextSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        // Divider().opacity(0.5).padding(.top, 8)
    }

    var statusSection: some View {
        Text(model.status)
            .foregroundColor(.ctTextPrimary)
            .font(.system(size: statusFontSize))
            .padding(.top, 8)
    }

    @ViewBuilder var footerSection: some View {
        if !model.lastUpdatedFormatted.isEmpty {
            HStack(spacing: 4) {
                Text(model.lastUpdatedFormatted)
                if !model.lastUpdatedRelativeDaysFormatted.isEmpty {
                    Text("•")
                    Text(model.lastUpdatedRelativeDaysFormatted)
                }
            }
            .font(.system(size: dateFontSize))
            .foregroundColor(.ctTextTertiary)
            .padding(.top, 8)
        } else {
            EmptyView()
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 8) {

            // OrbIndicator(color: model.color, size: orbSize).padding(2)
            BarIndicator(color: model.color, width: 8)

            VStack(alignment: .leading, spacing: 0) {
                formSection
                statusSection
                footerSection
            }
        }
        .padding(8)
        .background(Color.ctBackgroundSecondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CaseCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CaseCardView(model: PreviewDataRepository.case1)
            CaseCardView(model: PreviewDataRepository.case1WithoutForm)
            CaseCardView(model: PreviewDataRepository.case2)
        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
