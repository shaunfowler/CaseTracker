//
//  HistoryView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/21/22.
//

import Foundation
import SwiftUI

struct HistoryView: View {

    var history = [CaseStatusHistorical]()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .trailing) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .foregroundColor(.ctTextTertiary.opacity(0.3))
                        .frame(maxHeight: .infinity)
                        .frame(width: 4)
                        .offset(x: 2)
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(history, id: \.dateAdded) { historicalItem in
                            HStack(alignment: .center) {
                                Circle()
                                    .foregroundColor(historicalItem.color)
                                    .frame(width: 8, height: 8, alignment: .center)

                                VStack(alignment: .leading) {
                                    Text(historicalItem.status)
                                        .font(.caption2)
                                        .foregroundColor(.ctTextSecondary)
                                    if let lastUpdatedFormatted = historicalItem.lastUpdatedFormatted {
                                        Text(lastUpdatedFormatted)
                                            .font(.caption2)
                                            .foregroundColor(.ctTextTertiary)
                                    }
                                }

                                Spacer()
                            }
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HistoryView(history: [PreviewDataRepository().caseHistory.first!])
//                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.light)
            HistoryView(history: [PreviewDataRepository().caseHistory.first!])
//                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.dark)
            HistoryView(history: PreviewDataRepository().caseHistory)
//                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.light)
            HistoryView(history: PreviewDataRepository().caseHistory)
//                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 300, height: 220))
    }
}
