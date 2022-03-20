//
//  SafariView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/15/22.
//

import SwiftUI
import UIKit
import SafariServices

struct SafariView: UIViewControllerRepresentable {

    let url: URL

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        InteractionMetric.viewWebsite.send()
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) { }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://apple.com")!)
    }
}
