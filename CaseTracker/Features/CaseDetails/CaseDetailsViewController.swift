//
//  CaseDetailsViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import UIKit

protocol CaseDetailsViewProtocol: AnyObject {
    func historyLoaded(_ history: [CaseStatusHistorical])
}

class CaseDetailsViewController: UIViewController {

    private var interactor: CaseDetailsInteractorProtocol
    
    private var caseStatus: CaseStatus

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical
        return stackView
    }()

    private var historyStack = HistoryStackView()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    init(interactor: CaseDetailsInteractorProtocol, caseStatus: CaseStatus) {
        self.interactor = interactor
        self.caseStatus = caseStatus
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ctBackgroundPrimary
        title = caseStatus.receiptNumber

        interactor.loadHistory()

        setupNavbar()
        setupViews()
    }

    private func setupViews() {
        setupFormView()
        setupStatusView()
        setupHistoryView()
        setupRefreshStatusView()

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.contentSize = stackView.frame.size

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
        ])
    }

    private func setupFormView() {
        let detailGroupForm = DetailGroupView()
        detailGroupForm.title = "Form"

        if let formType = caseStatus.formType {
            detailGroupForm.addDetailView(UILabel.easyText(text: formType, font: .preferredFont(forTextStyle: .headline)))
        }
        if let formName = caseStatus.formName {
            detailGroupForm.addDetailView(UILabel.easyText(text: formName, font: .preferredFont(forTextStyle: .subheadline)))
        }

        stackView.addArrangedSubview(detailGroupForm)
    }

    private func setupStatusView() {
        let detailGroupForm = DetailGroupView()
        detailGroupForm.title = "Status"

        detailGroupForm.addDetailView(UILabel.easyText(text: caseStatus.status, font: .preferredFont(forTextStyle: .headline)))
        detailGroupForm.addDetailView(UILabel.easyText(
            text: caseStatus.body,
            font: .init(descriptor: .preferredFontDescriptor(withTextStyle: .body).withDesign(.serif)!, size: 14),
            alignment: .justified))
        detailGroupForm.spacing = 10

        stackView.addArrangedSubview(detailGroupForm)
    }

    private func setupHistoryView() {
        let detailGroupHistory = DetailGroupView()
        detailGroupHistory.title = "History"
        detailGroupHistory.addDetailView(historyStack)
        stackView.addArrangedSubview(detailGroupHistory)
    }

    private func setupRefreshStatusView() {
        if let refreshedDate = caseStatus.lastFetchedFormatted {
            let refreshedLabel = UILabel.easyText(text: "Refreshed at \(refreshedDate)")
            refreshedLabel.translatesAutoresizingMaskIntoConstraints = false
            refreshedLabel.font = .systemFont(ofSize: UIFont.smallSystemFontSize, weight: .bold)
            refreshedLabel.textAlignment = .center
            refreshedLabel.textColor = .systemGray
            view.addSubview(refreshedLabel)

            NSLayoutConstraint.activate([
                refreshedLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                refreshedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

    private func setupNavbar() {
        let moreMenu = UIMenu(children: [
            UIAction(title: "View on USCIS Website", image: UIImage(systemName: "globe")) { [weak self] action in
                guard let self else { return }
                self.present(WebViewController(receiptNumber: self.caseStatus.receiptNumber), animated: true)
            },
            UIAction(title: "Copy Receipt Number", image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                guard let self else { return }
                UIPasteboard.general.setValue(self.caseStatus.receiptNumber, forPasteboardType: "public.plain-text")
            },
            UIAction(title: "Delete Case", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.interactor.deleteCase()
            },
        ])

        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: moreMenu)

        navigationItem.rightBarButtonItem = moreButton
    }
}

extension CaseDetailsViewController: CaseDetailsViewProtocol {

    func historyLoaded(_ history: [CaseStatusHistorical]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            history.forEach { historicalItem in
                self.historyStack.addHistoricalItem(
                    status: historicalItem.status,
                    color: UIColor(historicalItem.color)
                )
            }
        }
    }
}
