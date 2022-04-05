//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct ActivityViewController1: UIViewControllerRepresentable {

    var url: URL
    var excludedActivityTypes: [UIActivity.ActivityType]?

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityViewController1>
    ) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityViewController1>
    ) {

    }
}

struct DetailsView: View {

    @Environment(\.dismiss) var dismiss
    @ScaledMetric var indicatorSize = 10
    @ScaledMetric var bodyFontSize = 15
    @StateObject var viewModel: DetailsViewModel

    let caseStatus: CaseStatus
    let removeCase: (String) -> Void

    var caseInfo: some View {
        List {
            if let formType = caseStatus.formType {
                Section("Form") {
                    VStack(alignment: .leading) {
                        Text("\(formType)")
                            .font(.headline)
                            .foregroundColor(.ctTextPrimary)

                        if let formName = caseStatus.formName {
                            Text(formName)
                                .font(.caption)
                                .foregroundColor(.ctTextTertiary)
                        }
                    }
                }
            }

            Section(header: Text("Status"), footer: statusFooter) {
                HStack(alignment: .center) {
                    OrbIndicator(color: caseStatus.color, size: indicatorSize)
                    Text(caseStatus.status)
                        .font(.subheadline)
                        .foregroundColor(.ctTextSecondary)
                }

                Text(caseStatus.body)
                    .textSelection(.enabled)
                    .multilineTextAlignment(.center)
                    .font(.system(size: bodyFontSize, design: .serif))
                    .foregroundColor(.ctTextSecondary)
            }

            history
        }
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
        .background(Color.ctBackgroundPrimary)
        .sheet(isPresented: $viewModel.isShowingActivityViewController) {
            ActivityViewController(url: CaseStatusURL.get(caseStatus.receiptNumber).url)
        }
    }

    @ViewBuilder var statusFooter: some View {
        if let lastFetchedFormatted = caseStatus.lastFetchedFormatted {
            Text("Refreshed at \(lastFetchedFormatted).")
                .font(.caption2)
                .foregroundColor(.ctTextTertiary.opacity(0.5))
        } else {
            EmptyView()
        }
    }

    @ViewBuilder var history: some View {
        if viewModel.isHistoryAvailable {
            Section(
                header: Text("History"),
                footer: Text("Complete case history is only available if the case status changed while the Case Tracker app was installed.")
                        .font(.caption2)
                        .foregroundColor(.ctTextTertiary.opacity(0.5))
            ) {
                HistoryView(history: viewModel.history)
            }
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
        caseInfo
            .background(Color.ctBackgroundPrimary)
            .navigationBarTitle(caseStatus.receiptNumber)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: onShareButtonPressed, label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                        })
                        Button(action: copyReceiptNumber) {
                            Label("Copy Receipt Number", systemImage: "doc.on.doc")
                        }
                        Button(action: openInWebView) {
                            Label("View on USCIS Website", systemImage: "globe")
                        }
                        Button(role: .destructive, action: removeCaseRequest) {
                            Label("Remove Case", systemImage: "trash")
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $viewModel.isPresentingWebView) {
                SafariView(url: CaseStatusURL.get(caseStatus.receiptNumber).url)
            }
            .alert(isPresented: $viewModel.isPresentingDeleteConfirmation) {
                removeAlert
            }
            .onAppear {
                MetricScreenView.viewCaseDetails.send(receiptNumber: caseStatus.receiptNumber)
            }
            .task {
                await viewModel.load(receiptNumber: caseStatus.receiptNumber)
            }
    }

    private func onMoreButtonPressed() {
        MetricInteraction.tapMoreNavBarButton.send()
        viewModel.isPresentingActionSheet = true
    }

    private func onShareButtonPressed() {
        MetricInteraction.tapShareNavBarButton.send()
        viewModel.isShowingActivityViewController.toggle()
    }

    private func copyReceiptNumber() {
        MetricInteraction.tapCopyReceiptNumberMenuButton.send()
        UIPasteboard.general.setValue(caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
    }

    private func openInWebView() {
        viewModel.isPresentingWebView.toggle()
    }

    private func removeCaseRequest() {
        MetricInteraction.tapRequestRemoveCaseMenuButton.send()
        viewModel.isPresentingDeleteConfirmation = true
    }

    private func performCaseRemove() {
        MetricInteraction.tapRemoveCaseConfirmAlertButton.send()
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

        DetailsView(
            viewModel: DetailsViewModel(repository: PreviewDataRepository()),
            caseStatus: PreviewDataRepository.case1WithoutForm
        ) { _ in }
    }
}
