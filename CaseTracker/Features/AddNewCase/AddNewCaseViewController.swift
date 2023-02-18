//
//  AddNewCaseViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-17.
//

import Foundation
import UIKit

class AddNewCaseViewController: ViewController<AddNewCaseFeatureViewAction, AddNewCaseFeatureViewState, AddNewCaseFeatureFeatureEvent> {

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onCloseTapped), for: .touchUpInside)
        return button
    }()

    private var receiptNumberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Receipt Number"
        label.textColor = .systemGray
        return label
    }()

    private var receiptNumberNote: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The format of a USCIS receipt number is as follows: 'XYZ0123456789'."
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private var receiptNumberTextInput: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 24)
        textView.backgroundColor = .systemFill
        textView.layer.cornerRadius = 4.0
        return textView
    }()

    private lazy var confirmButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.setTitle("Add Case", for: .normal)
        button.addTarget(self, action: #selector(onAddCaseTapped), for: .touchUpInside)
        return button
    }()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(closeButton)
        scrollView.addSubview(receiptNumberLabel)
        scrollView.addSubview(receiptNumberTextInput)
        scrollView.addSubview(receiptNumberNote)
        scrollView.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

            closeButton.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -10),

            receiptNumberLabel.leftAnchor.constraint(equalTo: receiptNumberTextInput.leftAnchor),
            receiptNumberLabel.rightAnchor.constraint(equalTo: receiptNumberTextInput.rightAnchor),
            receiptNumberLabel.bottomAnchor.constraint(equalTo: receiptNumberTextInput.topAnchor, constant: -8),
            receiptNumberLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            receiptNumberTextInput.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            receiptNumberTextInput.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            receiptNumberTextInput.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            receiptNumberTextInput.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),

            receiptNumberNote.leftAnchor.constraint(equalTo: receiptNumberTextInput.leftAnchor),
            receiptNumberNote.rightAnchor.constraint(equalTo: receiptNumberTextInput.rightAnchor),
            receiptNumberNote.topAnchor.constraint(equalTo: receiptNumberTextInput.bottomAnchor, constant: 8),
            receiptNumberNote.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            confirmButton.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            confirmButton.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            confirmButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            confirmButton.bottomAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])

        receiptNumberTextInput.becomeFirstResponder()
    }

    override func handle(viewState: AddNewCaseFeatureViewState, previousViewState: AddNewCaseFeatureViewState?) {
        confirmButton.isEnabled = !viewState.loading
        receiptNumberTextInput.isEditable = !viewState.loading
        if let error = viewState.error {
            let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }

    @objc private func onCloseTapped(_ sender: UIBarButtonItem) {
        presenter.interactor.handle(action: .closeTapped)
    }

    @objc private func onAddCaseTapped(_ sender: UIButton) {
        presenter.interactor.handle(action: .addCaseTapped(receiptNumberTextInput.text))
    }
}
