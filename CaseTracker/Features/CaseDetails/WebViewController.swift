//
//  WebViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-18.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let receiptNumber: String

    init(receiptNumber: String) {
        self.receiptNumber = receiptNumber
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let webview = WKWebView.forCase(withReceiptNumber: receiptNumber)
        view.addSubview(webview)
        webview.frame = view.bounds
    }
}
