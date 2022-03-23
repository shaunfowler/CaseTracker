//
//  HistoryView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/21/22.
//

import Foundation
import SwiftUI

struct HistoryView: View {

    var history = [CaseStatus]()

    var body: some View {
        VStack(alignment: .leading) {
            Text("History")
            VStack(alignment: .leading, spacing: 8) {
                ForEach(history, id: \.id) { historicalItem in
                    HStack(alignment: .center) {
                        Circle()
                            .foregroundColor(historicalItem.color)
                            .frame(width: 8, height: 8, alignment: .center)

                        VStack(alignment: .leading) {
                            Text(historicalItem.status)
                                .font(.caption)
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
            .background(Color.ctBackgroundSecondary)
            .cornerRadius(8)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: [PreviewDataRepository.case1, PreviewDataRepository.case2, PreviewDataRepository.case3])
    }
}
