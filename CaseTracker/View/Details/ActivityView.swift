//
//  ActivityView.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/18/22.
//

import SwiftUI
import UIKit

class UIActivityViewControllerHost: UIViewController {

    var url: URL?
    var completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler?

    override func viewDidAppear(_ animated: Bool) {
        share()
    }

    func share() {
        guard let url = url else { return }
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = completionWithItemsHandler
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(activityViewController, animated: true, completion: nil)
    }
}

struct ActivityViewController: UIViewControllerRepresentable {

    var url: URL
    @Binding var showing: Bool

    func makeUIViewController(context: Context) -> UIActivityViewControllerHost {
        // Create the host and setup the conditions for destroying it
        let result = UIActivityViewControllerHost()
        result.completionWithItemsHandler = { _, _, _, _ in
            // To indicate to the hosting view this should be "dismissed"
            self.showing = false
        }
        return result
    }

    func updateUIViewController(_ uiViewController: UIActivityViewControllerHost, context: Context) {
        uiViewController.url = url
    }

}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityViewController(url: URL(string: "https://apple.com")!, showing: .constant(true))
    }
}
