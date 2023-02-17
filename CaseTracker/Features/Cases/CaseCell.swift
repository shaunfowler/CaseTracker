//
//  CaseCell.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import UIKit

class CaseListCell: UICollectionViewCell {

    var caseStatus: CaseStatus? {
        didSet {
            bind()
        }
    }

    static let reuseId = "CaseListCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var formTypeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var formNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.addSubview(titleLabel)
        contentView.addSubview(formNameLabel)
        contentView.addSubview(formTypeLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            formTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            formTypeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),

            titleLabel.bottomAnchor.constraint(equalTo: formTypeLabel.bottomAnchor),
            titleLabel.leftAnchor.constraint(equalTo: formTypeLabel.rightAnchor, constant: 8),

            formNameLabel.topAnchor.constraint(equalTo: formTypeLabel.bottomAnchor, constant: 8),
            formNameLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            formNameLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),

            descriptionLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: formNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
        ])
    }

    private func bind() {
        guard let caseStatus else { return }

        titleLabel.text = caseStatus.receiptNumber
        descriptionLabel.text = caseStatus.status

        if let formType = caseStatus.formType {
            formTypeLabel.text = formType
            formTypeLabel.isHidden = false
        } else {
            formTypeLabel.isHidden = true
        }

        if let formName = caseStatus.formName {
            formNameLabel.text = formName
            formNameLabel.isHidden = false
        } else {
            formNameLabel.isHidden = true
        }
    }
}
