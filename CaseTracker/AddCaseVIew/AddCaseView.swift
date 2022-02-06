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
    @StateObject var viewModel = AddCaseViewModel()
    @FocusState var isTextFieldFocussed: Field?

    var onCaseAdded: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 36) {
            toolbarButtons
            Spacer()
            receiptNumberInputForm
            Spacer()
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
                isTextFieldFocussed = .receiptNumberTextField
            }
        }
    }

    var toolbarButtons: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }) {
                Text("Close")
                    .font(.system(size: 18))
            }
        }
    }

    var receiptNumberInputForm: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enter your receipt number")
                .font(.headline)

            TextField("XYZ0123456789", text: $viewModel.receiptNumber)
                .disableAutocorrection(true)
                .autocapitalization(.allCharacters)
                .buttonBorderShape(.capsule)
                .padding()
                .background(Color("CaseRowBackgroundColor"))
                .cornerRadius(8)
                .focused($isTextFieldFocussed, equals: .receiptNumberTextField)

            Button(action: {
                Task {
                    await viewModel.attemptAddCase()
                    if !viewModel.showError {
                        dismiss()
                        await onCaseAdded()
                    }
                }
            }) {
                Text("Add Case")
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding([.top, .bottom], 12)
            .foregroundColor(.white)
            .background(.blue)
            .cornerRadius(8)
            .padding(.top, 36)
        }
    }
}

struct AddCaseView_Previews: PreviewProvider {
    static var previews: some View {
        AddCaseView { }
    }
}
