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

    private var container: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ctBackgroundSecondary
        view.layer.cornerRadius = 4.0
        view.layer.shadowColor = UIColor.ctShadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        return view
    }()

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

    private  lazy var formNameLabel: UILabel = {
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

    private var dateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        return label
    }()

    private var indicatorView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemFill
        view.layer.cornerRadius = 2.0
        return view
    }()

    lazy var titleLabelLeftAnchorConstraint: NSLayoutConstraint = titleLabel.leftAnchor.constraint(
        equalTo: formTypeLabel.rightAnchor,
        constant: 8)

    lazy var formNameLabelTopAnchorConstraint: NSLayoutConstraint = formNameLabel.topAnchor.constraint(
        equalTo: formTypeLabel.bottomAnchor,
        constant: 8)

    override func prepareForReuse() {
        super.prepareForReuse()

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(container)
        container.addSubview(indicatorView)
        container.addSubview(titleLabel)
        container.addSubview(formNameLabel)
        container.addSubview(formTypeLabel)
        container.addSubview(descriptionLabel)
        container.addSubview(dateLabel)

        titleLabelLeftAnchorConstraint.constant = caseStatus?.formType == nil ? 0 : 8
        formNameLabelTopAnchorConstraint.constant = caseStatus?.formName == nil ? 0 : 8

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            container.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 10),
            container.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -10),

            indicatorView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
            indicatorView.leftAnchor.constraint(equalTo: container.layoutMarginsGuide.leftAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 4),

            formTypeLabel.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            formTypeLabel.leftAnchor.constraint(equalTo: indicatorView.rightAnchor, constant: 12),
            formTypeLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            titleLabelLeftAnchorConstraint,

            formNameLabelTopAnchorConstraint,
            formNameLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            formNameLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),

            descriptionLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: container.layoutMarginsGuide.rightAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: formNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -8),

            dateLabel.leftAnchor.constraint(equalTo: formTypeLabel.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: formTypeLabel.rightAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.layoutMarginsGuide.bottomAnchor),
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

        dateLabel.text = "Howdy"

        titleLabelLeftAnchorConstraint.constant = caseStatus.formType == nil ? 0 : 8
        formNameLabelTopAnchorConstraint.constant = caseStatus.formName == nil ? 0 : 8

        setNeedsLayout()
    }
}
