//
//  DetailsViewController.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import UIKit
import SafariServices
import CaseTrackerCore

class DetailsViewController: UIViewController {

    // MARK: - Private Properties

    private let caseStatus: CaseStatus
    private let onRemove: (CaseStatus) -> Void

    // MARK: - View Computed Properties

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 15
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var titleView: UIView? = {
        guard let formType = caseStatus.formType else { return nil }
        let title = UILabel()
        title.numberOfLines = 0
        title.font = .preferredFont(forTextStyle: .headline)
        title.text = "Form \(formType)"
        return title
    }()

    private lazy var subtitleView: UIView = {
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
        return subtitleStackView
    }()

    private lazy var bodyView: UIView = {
        let bodyContainer = UIView()
        bodyContainer.translatesAutoresizingMaskIntoConstraints = false
        bodyContainer.backgroundColor = UIColor(named: "CaseRowBackgroundColor")
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

        bodyContainer.addSubview(body)
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.topAnchor),
            body.bottomAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.bottomAnchor),
            body.leadingAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: bodyContainer.layoutMarginsGuide.trailingAnchor)
        ])

        return bodyContainer
    }()

    private lazy var viewOnWebsiteButton: UIView = {
        var configuration = UIButton.Configuration.borderless()
        configuration.title = "Visit on USCIS Website"
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(viewOnWebsiteTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialization

    init(caseStatus: CaseStatus, onRemove: @escaping (CaseStatus) -> Void) {
        self.caseStatus = caseStatus
        self.onRemove = onRemove
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "HomeBackgroundColor")
        title = caseStatus.receiptNumber

        setupNavigationBar()
        setupScrollView()
        setupStackView()
        setupStackViewContents()
    }

    // MARK: - Layout

    private func setupNavigationBar() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                guard let self = self else { return }
                let activityViewController = UIActivityViewController(
                    activityItems: [CaseStatusURL.get(self.caseStatus.receiptNumber).url],
                    applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
            },
            UIAction(title: "Copy Receipt Number", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                guard let self = self else { return }
                UIPasteboard.general.setValue(self.caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
            },
            UIAction(title: "Remove", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                guard let self = self else { return }
                self.onRemove(self.caseStatus)
                self.navigationController?.popViewController(animated: true)
            }
        ])
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.rightBarButtonItems = [button]
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
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])
    }

    private func setupStackViewContents() {
        if let titleView = titleView {
            stackView.addArrangedSubview(titleView)
        }
        stackView.addArrangedSubview(subtitleView)
        stackView.addArrangedSubview(bodyView)
        stackView.addArrangedSubview(viewOnWebsiteButton)

        stackView.setCustomSpacing(30, after: bodyView)
    }

    // MARK: - Selectors

    @objc private func viewOnWebsiteTapped(_ sender: UIButton) {
        let url = CaseStatusURL.get(caseStatus.receiptNumber).url
        if UIApplication.shared.canOpenURL(url) {
            present(SFSafariViewController(url: url), animated: true)
        }
    }

    @objc private func moreTapped() {
        print("More")
    }
}
