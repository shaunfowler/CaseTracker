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

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var formTypeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var formNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private var indicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 2.0
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.addSubview(indicatorView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(formNameLabel)
        contentView.addSubview(formTypeLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            indicatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            indicatorView.widthAnchor.constraint(equalToConstant: 4),

            formTypeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            formTypeLabel.leftAnchor.constraint(equalTo: indicatorView.rightAnchor, constant: 8),
            formTypeLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leftAnchor.constraint(equalTo: formTypeLabel.rightAnchor, constant: caseStatus?.formName == nil ? 0 : 8),

            formNameLabel.topAnchor.constraint(equalTo: formTypeLabel.bottomAnchor, constant: caseStatus?.formName == nil ? 0 : 8),
            formNameLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            formNameLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),

            descriptionLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: formNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: 8),
        ])
    }

    private func bind() {
        guard let caseStatus else { return }

        titleLabel.text = caseStatus.receiptNumber
        descriptionLabel.text = caseStatus.status
        indicatorView.backgroundColor = UIColor(caseStatus.color)

        formTypeLabel.isHidden = caseStatus.formType == nil
        formTypeLabel.text = caseStatus.formType

        formNameLabel.isHidden = caseStatus.formName == nil
        formNameLabel.text = caseStatus.formName
    }
}
