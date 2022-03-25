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

    @StateObject var viewModel: DetailsViewModel

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

            if viewModel.isShowingActivityViewController {
                ActivityViewController(url: CaseStatusURL.get(caseStatus.receiptNumber).url,
                                       showing: $viewModel.isShowingActivityViewController)
            }
        }
    }

    var externalLinkButton: some View {
        Button("View on USCIS Website") {
            viewModel.isPresentingWebView.toggle()
        }
        .sheet(isPresented: $viewModel.isPresentingWebView) {
            SafariView(url: CaseStatusURL.get(caseStatus.receiptNumber).url)
        }
        .padding(.vertical)
    }

    @ViewBuilder var history: some View {
        if viewModel.isHistoryAvailable {
            HistoryView(history: viewModel.history)
        } else {
            EmptyView()
        }
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
            history
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
                .confirmationDialog("", isPresented: $viewModel.isPresentingActionSheet, actions: {
                    Button("Copy Receipt Number", action: copyReceiptNumber)
                    Button("Remove Case", role: .destructive, action: removeCaseRequest)
                        .alert(isPresented: $viewModel.isPresentingDeleteConfirmation) { removeAlert }
                })
            }
        }
        .onAppear {
            InteractionMetric.viewCaseDetails.send()
         }
        .task {
            await viewModel.load(receiptNumber: caseStatus.receiptNumber)
        }
    }

    private func onMoreButtonPressed() {
        InteractionMetric.tapMoreNavBarButton.send()
        viewModel.isPresentingActionSheet = true
    }

    private func onShareButtonPressed() {
        InteractionMetric.tapShareNavBarButton.send()
        viewModel.isShowingActivityViewController.toggle()
    }

    private func copyReceiptNumber() {
        InteractionMetric.tapCopyReceiptNumberMenuButton.send()
        UIPasteboard.general.setValue(caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
    }

    private func removeCaseRequest() {
        InteractionMetric.tapRequestRemoveCaseMenuButton.send()
        viewModel.isPresentingDeleteConfirmation = true
    }

    private func performCaseRemove() {
        InteractionMetric.tapRemoveCaseConfirmAlertButton.send()
        removeCase(caseStatus.receiptNumber)
        dismiss()
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(
            viewModel: DetailsViewModel(repository: PreviewDataRepository()),
            caseStatus: PreviewDataRepository.case1
        ) { _ in }
    }
}
