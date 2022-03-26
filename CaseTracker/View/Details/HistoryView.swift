//
//  HistoryView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/21/22.
//

import Foundation
import SwiftUI

struct HistoryView: View {

    @State var messageVisible = false

    var history = [CaseStatusHistorical]()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("History")
                    .font(.headline)
                Spacer()
                Button(
                    action: {
                        withAnimation {
                            messageVisible.toggle()
                        }
                    }, label: {
                        Image(systemName: "questionmark.circle")
                            .font(.headline)
                            .foregroundColor(.ctTextTertiary)
                    })
                    .accessibility(identifier: "historyInfoButton")
            }

            if messageVisible {
                Text("Case history is only available below if the case status changed while the Case Tracker app is installed.")
                    .font(.caption2)
                    .foregroundColor(.ctTextTertiary)
            }

            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.ctTextTertiary.opacity(0.2))
                    .frame(maxHeight: .infinity)
                    .frame(width: 1)
                    .offset(x: 3.5)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(history, id: \.date) { historicalItem in
                        HStack(alignment: .center) {
                            Circle()
                                .foregroundColor(historicalItem.color)
                                .frame(width: 8, height: 8, alignment: .center)

                            VStack(alignment: .leading) {
                                Text(historicalItem.status)
                                    .font(.caption2)
                                    .foregroundColor(.ctTextSecondary)
                                Text(historicalItem.lastUpdatedFormatted)
                                    .font(.caption2)
                                    .foregroundColor(.ctTextTertiary)
                            }

                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .background(Color.ctBackgroundSecondary)
            .cornerRadius(8)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HistoryView(history: [PreviewDataRepository().caseHistory.first!])
                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.light)
            HistoryView(history: [PreviewDataRepository().caseHistory.first!])
                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.dark)
            HistoryView(history: PreviewDataRepository().caseHistory)
                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.light)
            HistoryView(history: PreviewDataRepository().caseHistory)
                .padding()
                .background(Color.ctBackgroundPrimary)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.fixed(width: 300, height: 220))
    }
}
