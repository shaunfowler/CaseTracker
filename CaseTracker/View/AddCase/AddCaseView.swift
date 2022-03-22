//
//  AddCaseView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/1/22.
//

import SwiftUI

struct AddCaseView: View {

    enum Field {
        case receiptNumberTextField
    }

    @Environment(\.dismiss) var dismiss
    @FocusState var focussedElement: Field?

    @ObservedObject var viewModel: AddCaseViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            toolbarButtons
            Spacer()
            receiptNumberInputForm
        }
        .padding()
        .background(Color.ctBackgroundPrimary)
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Could Not Fetch Case"),
                message: Text("Failed to get case status. Please double check the receipt number.")
            )
        }
        .onAppear {
            InteractionMetric.viewAddCase.send()
        }
    }

    var toolbarButtons: some View {
        HStack {
            Spacer()
            Button(action: {
                InteractionMetric.tabCloseAddCaseModalButton.send()
                dismiss()
            }, label: {
                Text("Close")
                    .font(.body)
            })
        }
    }

    var receiptNumberInputForm: some View {
        VStack(alignment: .leading, spacing: 16) {

            Spacer()

            Text("Enter your receipt number")
                .font(.headline)
                .foregroundColor(.ctTextPrimary)

            TextField("XYZ0123456789", text: $viewModel.receiptNumber)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .buttonBorderShape(.capsule)
                .padding()
                .background(Color.ctBackgroundSecondary)
                .foregroundColor(.ctTextSecondary)
                .cornerRadius(4)
                .focused($focussedElement, equals: .receiptNumberTextField)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.focussedElement = .receiptNumberTextField
                    }
                }

            Spacer()

            PrimaryButton(title: "Add Case",
                          disabled: viewModel.receiptNumber.isEmpty,
                          loading: viewModel.isLoading,
                          fullWidth: true) {
                Task {
                    InteractionMetric.tapAddCaseSubmitModalButton.send()
                    await viewModel.attemptAddCase()
                    if !viewModel.showError {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AddCaseView_Previews: PreviewProvider {
    static var previews: some View {
        // Embed in ZStack for FocusState preview crash bug... lol
        ZStack {
            AddCaseView(viewModel: AddCaseViewModel(repository: PreviewDataRepository()))
        }
    }
}
