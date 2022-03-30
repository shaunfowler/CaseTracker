//
//  CaseStatusNavigationLink.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct CaseStatusNavigationLink<Content: View>: View {

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
                        // CaseRowView(model: model)
                        CaseCardView(model: model)
                    })
                    .buttonStyle(CaseRowViewButtonStyle())
                    .frame(maxWidth: .infinity)
            }
        )
            .padding(.trailing, 8)
            .background(Color.ctBackgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .shadow(color: Color.ctShadow.opacity(0.2), radius: 8, x: 0, y: 0)
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

struct CaseStatusNavigationLink_Previews: PreviewProvider {

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
                CaseStatusNavigationLink(model: model1) { EmptyView() }
                CaseStatusNavigationLink(model: model2) { EmptyView() }
                CaseStatusNavigationLink(model: model3) { EmptyView() }
            }
            .preferredColorScheme(.light)

            VStack(alignment: .leading) {
                CaseStatusNavigationLink(model: model1) { EmptyView() }
                CaseStatusNavigationLink(model: model2) { EmptyView() }
                CaseStatusNavigationLink(model: model3) { EmptyView() }
            }
            .preferredColorScheme(.dark)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
