//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct DetailsView: View {

    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss

    @State var isPresentingActionSheet = false
    @State var isPresentingDeleteConfirmation = false
    @State var isShowingActivityViewController = false
    @State var isPresentingWebView = false

    let caseStatus: CaseStatus
    let removeCase: (String) -> Void

    var caseInfo: some View {
        ZStack {
            VStack(alignment: .leading) {
                if let formType = caseStatus.formType {
                    Text("Form \(formType)")
                        .font(.headline)
                        .foregroundColor(.ctTextPrimary)
                }

                HStack(alignment: .firstTextBaseline) {
                    Circle()
                        .foregroundColor(caseStatus.color)
                        .frame(width: 8, height: 8, alignment: .center)
                        .offset(y: -2)
                    Text(caseStatus.status)
                        .foregroundColor(.ctTextSecondary)
                }

                Text(caseStatus.body)
                    .multilineTextAlignment(.center)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.ctTextSecondary)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.ctBackgroundSecondary)
                    .cornerRadius(8)
            }

            if isShowingActivityViewController {
                ActivityViewController(url: CaseStatusURL.get(caseStatus.receiptNumber).url,
                                       showing: $isShowingActivityViewController)
            }
        }
    }

    var externalLinkButton: some View {
        Button("View on USCIS Website") {
            isPresentingWebView.toggle()
        }
        .sheet(isPresented: $isPresentingWebView) {
            SafariView(url: CaseStatusURL.get(caseStatus.receiptNumber).url)
        }
        .padding(.vertical, 24)
    }

    var history: some View {
        EmptyView()
    }

    var removeAlert: Alert {
        Alert(
            title: Text("Remove Case"),
            message: Text("Are you sure you want to remove case \(caseStatus.receiptNumber)?"),
            primaryButton: .destructive(Text("Remove"), action: performCaseRemove),
            secondaryButton: .cancel())
    }

    var body: some View {
        ScrollView {
            caseInfo
            externalLinkButton
            // history
        }
        .padding()
        .background(Color.ctBackgroundPrimary)
        .navigationBarTitle(caseStatus.receiptNumber)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: onShareButtonPressed, label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                })
                Button(action: onMoreButtonPressed) {
                    Label("More", systemImage: "ellipsis.circle")
                }
                .confirmationDialog("", isPresented: $isPresentingActionSheet, actions: {
                    Button("Copy Receipt Number", action: copyReceiptNumber)
                    Button("Remove Case", role: .destructive, action: removeCaseRequest)
                        .alert(isPresented: $isPresentingDeleteConfirmation) { removeAlert }
                })
            }
        }
        .onAppear {
            InteractionMetric.viewCaseDetails.send()
        }
    }

    private func onMoreButtonPressed() {
        InteractionMetric.tapMoreNavBarButton.send()
        isPresentingActionSheet = true
    }

    private func onShareButtonPressed() {
        InteractionMetric.tapShareNavBarButton.send()
        isShowingActivityViewController.toggle()
    }

    private func copyReceiptNumber() {
        InteractionMetric.tapCopyReceiptNumberMenuButton.send()
        UIPasteboard.general.setValue(caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
    }

    private func removeCaseRequest() {
        InteractionMetric.tapRequestRemoveCaseMenuButton.send()
        isPresentingDeleteConfirmation = true
    }

    private func performCaseRemove() {
        InteractionMetric.tapRemoveCaseConfirmAlertButton.send()
        removeCase(caseStatus.receiptNumber)
        dismiss()
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(caseStatus: PreviewDataRepository.case1) { _ in }
    }
}
