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
    var fullWidth = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .padding(.vertical)
                .padding(.horizontal, 36)
                .frame(maxWidth: fullWidth ? .infinity : .none)
        }
        .disabled(disabled)
        .foregroundColor(.white)
        .background(.blue)
        .clipShape(Capsule())
        .opacity(disabled ? 0.5 : 1.0)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PrimaryButton(title: "Hello", action: {})
            PrimaryButton(title: "Hello", disabled: true, action: {})
            PrimaryButton(title: "Hello", fullWidth: true, action: {})
            PrimaryButton(title: "Hello", disabled: true, fullWidth: true, action: {})
        }
    }
}
