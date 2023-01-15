//
//  SafariView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/15/22.
//

import SwiftUI
import UIKit
import SafariServices
import WebKit

struct WebViewWrapped: UIViewRepresentable {

    let request: URLRequest

    func makeUIView(
        context: UIViewRepresentableContext<WebViewWrapped>
    ) -> WKWebView {
        MetricScreenView.viewWebsite.send()
        return WKWebView()
    }

    func updateUIView(
        _ uiView: WKWebView,
        context: UIViewRepresentableContext<WebViewWrapped>
    ) {
        uiView.load(request)
    }
}

struct SafariView: View {
    let request: URLRequest
    var body: some View {
        WebViewWrapped(request: request)
            .edgesIgnoringSafeArea(.all)
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(request: URLRequest(url: URL(string: "https://apple.com")!))
    }
}
