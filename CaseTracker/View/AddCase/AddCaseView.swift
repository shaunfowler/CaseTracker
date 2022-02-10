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
    @FocusState var isTextFieldFocussed

    @ObservedObject var viewModel: AddCaseViewModel
    var onCaseAdded: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            toolbarButtons
            Spacer()
            receiptNumberInputForm
        }
        .padding()
        .background(Color("HomeBackgroundColor"))
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Could Not Fetch Case"),
                message: Text("Failed to get case status. Please double check the receipt number.")
            )
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isTextFieldFocussed = true
            }
        }
    }

    var toolbarButtons: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }, label: {
                Text("Close")
                    .font(.system(size: 18))
            })
        }
    }

    var receiptNumberInputForm: some View {
        VStack(alignment: .leading, spacing: 16) {

            Spacer()

            Text("Enter your receipt number")
                .font(.headline)

            TextField("XYZ0123456789", text: $viewModel.receiptNumber)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .buttonBorderShape(.capsule)
                .padding()
                .background(Color("CaseRowBackgroundColor"))
                .cornerRadius(4)
                .focused($isTextFieldFocussed)

            Spacer()

            PrimaryButton(title: "Add Case", disabled: viewModel.receiptNumber.isEmpty, fullWidth: true) {
                Task {
                    await viewModel.attemptAddCase()
                    if !viewModel.showError {
                        dismiss()
                        await onCaseAdded()
                    }
                }
            }
        }
    }
}

struct AddCaseView_Previews: PreviewProvider {
    static var previews: some View {
        AddCaseView(viewModel: AddCaseViewModel(repository: PreviewDataRepository())) { }
    }
}