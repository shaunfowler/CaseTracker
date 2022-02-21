//
//  AddCaseViewController.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import UIKit
import CaseTrackerCore

class AddCaseViewController: UIViewController {
    
    @IBOutlet var receiptNumberTextField: PaddedTextField!
    @IBOutlet var addCaseButton: UIButton!
    @IBOutlet var closeButton: UIButton!
    
    let viewModel: AddCaseViewModel
    
    let onDismiss: () -> Void
    
    init(viewModel: AddCaseViewModel, onDismiss: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onDismiss = onDismiss
        super.init(nibName: "AddCaseViewController", bundle: nil)
        
        view.alpha = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        receiptNumberTextField.backgroundColor = .ctBackground
        receiptNumberTextField.borderStyle = .none
        receiptNumberTextField.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        receiptNumberTextField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        addCaseButton.isEnabled = false
        addCaseButton.addTarget(self, action: #selector(addCaseTapped), for: .touchUpInside)
        addCaseButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
    }
    
    @objc func textChanged(_ sender: UITextField) {
        viewModel.receiptNumber = sender.text ?? ""
        if let text = sender.text {
            addCaseButton.isEnabled = !text.isEmpty
        }
    }
    
    @objc func addCaseTapped(_ sender: UIButton) {
        Task {
            await viewModel.attemptAddCase()
            onDismiss()
            dismiss(animated: true)
        }
    }
    
    @objc func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
