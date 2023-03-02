//
//  FTUEViewController.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-03-01.
//

import UIKit

class FTUEViewController: UIViewController {

    var onAddCaseTapped: () -> Void

    private lazy var ftueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "No cases have been added"
        return label
    }()

    private lazy var ftueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Case", for: .normal)
        button.configuration = .borderedProminent()
        button.addTarget(self, action: #selector(onAddCaseTappedAction), for: .touchUpInside)
        return button
    }()

    init(onAddCaseTapped: @escaping () -> Void) {
        self.onAddCaseTapped = onAddCaseTapped
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(ftueLabel)
        view.addSubview(ftueButton)

        NSLayoutConstraint.activate([
            ftueLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            ftueLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            ftueButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            ftueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

    @objc func onAddCaseTappedAction() {
        self.onAddCaseTapped()
    }
}
