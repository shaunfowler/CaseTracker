//
//  SafariView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/15/22.
//

import SwiftUI
import UIKit
import SafariServices

struct SafariViewWrapped: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariViewWrapped>
    ) -> SFSafariViewController {
        MetricScreenView.viewWebsite.send()
        let viewController = SFSafariViewController(url: url)
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariViewWrapped>
    ) { }
}

struct SafariView: View {
    let url: URL
    var body: some View {
        SafariViewWrapped(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://apple.com")!)
    }
}
