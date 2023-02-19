//
//  WKWebView+forCase.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-18.
//

import WebKit

extension WKWebView {

    static func forCase(withReceiptNumber receiptNumber: String) -> WKWebView {
        let webview = WKWebView(frame: .zero)
        webview.load(CaseStatusURL.post(receiptNumber).request)
        return webview
    }
}
