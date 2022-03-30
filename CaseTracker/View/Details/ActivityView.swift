//
//  ActivityView.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/18/22.
//

import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {

    var url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

struct ActivityView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            Text("Share Content")
        }
        .sheet(isPresented: .constant(true)) {
            ActivityViewController(url: URL(string: "https://apple.com")!)
        }
    }
}
