//
//  AddCaseViewController.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import UIKit
import CaseTrackerCore

class AddCaseViewController: UIViewController {

    @IBOutlet var receiptNumberTextField: UITextField!
    @IBOutlet var addCaseButton: UIButton!

    let viewModel: AddCaseViewModel

    let onDismiss: () -> Void

    init(viewModel: AddCaseViewModel, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        super.init(nibName: "AddCaseViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        receiptNumberTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        addCaseButton.isEnabled = false
        addCaseButton.addTarget(self, action: #selector(addCaseTapped), for: .touchUpInside)
    }

    @objc func textChanged(_ sender: UITextField) {
        viewModel.receiptNumber = sender.text ?? ""
        if let text = sender.text {
            addCaseButton.isEnabled = !text.isEmpty
        }
    }

    @objc func addCaseTapped(_ sender: UIButton) {
        print("tapped")
        Task {
            await viewModel.attemptAddCase()
            onDismiss()
            dismiss(animated: true)
        }
    }
}
