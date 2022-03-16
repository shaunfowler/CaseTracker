//
//  DetailsView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI
import CaseTrackerCore

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
                    .background(Color.ctRowBackground)
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
        .padding(.top, 24)
    }

    var removeAlert: Alert {
        Alert(
            title: Text("Remove Case"),
            message: Text("Are you sure you want to remove case \(caseStatus.receiptNumber)?"),
            primaryButton: .destructive(Text("Remove")) {
                removeCase(caseStatus.receiptNumber)
                dismiss()
            },
            secondaryButton: .cancel())
    }

    var body: some View {
        ScrollView {
            caseInfo
            externalLinkButton
        }
        .padding()
        .background(Color.ctBackground)
        .navigationBarTitle(caseStatus.receiptNumber)
        .alert(isPresented: $isPresentingDeleteConfirmation) { removeAlert }
        .confirmationDialog(Text(""), isPresented: $isPresentingActionSheet, actions: {
            Button("Copy Receipt Number") {
                copyReceiptNumber()
            }
            Button("Remove Case", role: .destructive) {
                removeCaseRequest()
            }
        })
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: { isShowingActivityViewController.toggle() }, label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                })
                Button(action: onMoreButtonPressed) {
                    Label("More", systemImage: "ellipsis.circle")
                }
            }
        }
        .popover(isPresented: $isPresentingWebView) {
            SafariView(url: CaseStatusURL.get(caseStatus.receiptNumber).url)
        }
    }

    private func onMoreButtonPressed() {
        isPresentingActionSheet = true
    }

    private func copyReceiptNumber() {
        UIPasteboard.general.setValue(caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
    }

    private func removeCaseRequest() {
        isPresentingDeleteConfirmation = true
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(caseStatus: PreviewDataRepository.case1) { _ in }
    }
}
