//
//  PrimaryButton.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2/8/22.
//

import SwiftUI

struct PrimaryButton: View {

    let title: String
    var disabled = false
    var loading = false
    var fullWidth = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .trailing) {
                Text(title)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .padding(.horizontal, 48)
                    .frame(maxWidth: fullWidth ? .infinity : .none)

                if loading {
                    ProgressView()
                        .padding(.horizontal)
                }
            }
        }
        .disabled(disabled || loading)
        .foregroundColor(.white)
        .background(.blue)
        .clipShape(Capsule())
        .opacity((disabled || loading) ? 0.5 : 1.0)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Hello", action: {})
            PrimaryButton(title: "Hello", disabled: true, action: {})
            PrimaryButton(title: "Hello", fullWidth: true, action: {})
            PrimaryButton(title: "Hello", disabled: true, fullWidth: true, action: {})

            PrimaryButton(title: "Hello", loading: true, action: {})
            PrimaryButton(title: "Hello", disabled: true, loading: true, action: {})
            PrimaryButton(title: "Hello", disabled: true, loading: true, fullWidth: true, action: {})
        }
    }
}
