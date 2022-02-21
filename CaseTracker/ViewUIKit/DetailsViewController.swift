//
//  DetailsViewController.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import UIKit
import CaseTrackerCore

class DetailsViewController: UIViewController {

    private let caseStatus: CaseStatus

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()

    init(caseStatus: CaseStatus) {
        self.caseStatus = caseStatus
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = caseStatus.receiptNumber

        setupScrollView()
        setupStackView()
        setupStackViewContents()
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }

    private func setupStackView() {
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            // frameLayoutGuide
            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            // contentLayoutGuide
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
    }

    private func setupStackViewContents() {

        if let formType = caseStatus.formType {
            let title = UILabel()
            title.numberOfLines = 0
            title.font = .preferredFont(forTextStyle: .headline)
            title.text = "Form \(formType)"
            stackView.addArrangedSubview(title)
        }

        let subtitleIndicator = UIView()
        subtitleIndicator.widthAnchor.constraint(equalToConstant: 8).isActive = true
        subtitleIndicator.heightAnchor.constraint(equalToConstant: 8).isActive = true
        subtitleIndicator.backgroundColor = UIColor(caseStatus.color)
        subtitleIndicator.layer.cornerRadius = 4
        subtitleIndicator.alpha = 0.75

        let subtitle = UILabel()
        subtitle.numberOfLines = 0
        subtitle.text = caseStatus.status

        let subtitleStackView = UIStackView(frame: .zero)
        subtitleStackView.spacing = 10
        subtitleStackView.alignment = .center
        subtitleStackView.axis = .horizontal
        subtitleStackView.addArrangedSubview(subtitleIndicator)
        subtitleStackView.addArrangedSubview(subtitle)
        stackView.addArrangedSubview(subtitleStackView)

        let bodyContainer = UIView()
        bodyContainer.translatesAutoresizingMaskIntoConstraints = false
        bodyContainer.backgroundColor = .quaternarySystemFill
        bodyContainer.layer.cornerRadius = 8
        stackView.addArrangedSubview(bodyContainer)

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        if let descriptor = body.font.fontDescriptor.withDesign(.serif) {
            body.font = UIFont(descriptor: descriptor, size: 0.0)
        }
        body.textAlignment = .center
        body.text = caseStatus.body
        body.numberOfLines = 0
        stackView.addArrangedSubview(body)

        bodyContainer.addSubview(body)

        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.topAnchor),
            body.bottomAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.trailingAnchor)
        ])
    }
}
