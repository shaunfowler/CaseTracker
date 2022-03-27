//
//  CaseRowView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct CaseRowView<Content: View>: View {

    @ScaledMetric var fontSize: CGFloat = 14
    @State var selected: Bool = false

    let model: CaseStatus
    let destination: () -> Content

    init(model: CaseStatus, @ViewBuilder destination: @escaping () -> Content) {
        self.model = model
        self.destination = destination
    }

    var body: some View {
        NavigationLink(
            destination: destination(),
            isActive: $selected,
            label: {
                Button(
                    action: {
                        selected = true
                    },
                    label: {
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

                            Spacer()
                        }
                        .background(Color.ctBackgroundSecondary.opacity(0.01)) // Increase touch area
                        .padding(8)
                    })
                    .buttonStyle(CaseRowViewButtonStyle())
                    .frame(maxWidth: .infinity)
            }
        )
            .padding(.trailing, 8)
            .background(Color.ctBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .accessibility(identifier: model.receiptNumber)
    }
}

struct CaseRowViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .opacity(configuration.isPressed ? 0.5 : 1)
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
                CaseRowView(model: model1) { EmptyView() }
                CaseRowView(model: model2) { EmptyView() }
                CaseRowView(model: model3) { EmptyView() }
            }
            .preferredColorScheme(.light)

            VStack(alignment: .leading) {
                CaseRowView(model: model1) { EmptyView() }
                CaseRowView(model: model2) { EmptyView() }
                CaseRowView(model: model3) { EmptyView() }
            }
            .preferredColorScheme(.dark)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
