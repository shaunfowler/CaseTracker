//
//  CaseDetailsViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import UIKit

class CaseDetailsViewController: ViewController<CaseDetailsFeatureViewAction, CaseDetailsFeatureViewState, CaseDetailsFeatureFeatureEvent> {

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        stackView.axis = .vertical
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupNavbar()
        setupViews()
    }

    private func setupViews() {
        let formType = presenter.viewState.caseStatus.formType
        let formName = presenter.viewState.caseStatus.formName
        if formName != nil || formType != nil {
            stackView.addArrangedSubview(UILabel.easyText(text: "FORM", font: .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .semibold)))
            stackView.addArrangedSubview(UILabel.easyText(text: formType ?? "", font: .systemFont(ofSize: UIFont.systemFontSize, weight: .bold)))
            let nameLabel = UILabel.easyText(text: formName ?? "", font: .systemFont(ofSize: UIFont.systemFontSize))
            stackView.addArrangedSubview(nameLabel)
            stackView.setCustomSpacing(36, after: nameLabel)
        }

        let status = presenter.viewState.caseStatus.status
        let body = presenter.viewState.caseStatus.body
        stackView.addArrangedSubview(UILabel.easyText(text: "STATUS", font: .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .semibold)))
        stackView.addArrangedSubview(UILabel.easyText(text: status, font: .systemFont(ofSize: UIFont.systemFontSize, weight: .bold)))
        stackView.addArrangedSubview(UILabel.easyText(
            text: body,
            font: .init(
                descriptor: .preferredFontDescriptor(withTextStyle: .body).withDesign(.serif)!, size: 14),
            alignment: .center,
            numberOfLines: 0))

        if let refreshedDate = presenter.viewState.caseStatus.lastFetchedFormatted {
            let refreshedLabel = UILabel.easyText(text: "Refreshed at \(refreshedDate)")
            stackView.addArrangedSubview(refreshedLabel)
            stackView.setCustomSpacing(36, after: refreshedLabel)
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupNavbar() {
        let moreMenu = UIMenu(children: [
            UIAction(title: "View on USCIS Website", image: UIImage(systemName: "globe")) { [weak self] action in
                guard let self else { return }
                self.present(WebViewController(receiptNumber: self.presenter.viewState.caseStatus.receiptNumber), animated: true)
            },
            UIAction(title: "Copy Receipt Number", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                guard let self else { return }
                UIPasteboard.general.setValue(self.presenter.viewState.caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
            },
            UIAction(title: "Delete Case", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.presenter.interactor.handle(action: .deleteCaseTapped)
            },
        ])

        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: moreMenu)

        navigationItem.rightBarButtonItem = moreButton
    }

    override func handle(viewState: CaseDetailsFeatureViewState, previousViewState: CaseDetailsFeatureViewState?) {
        title = viewState.caseStatus.receiptNumber
    }
}
