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
        view.backgroundColor = .tertiarySystemFill
        view.layer.cornerRadius = 4.0
        return view
    }()

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var outerStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    private var titleStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
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
        container.addSubview(outerStackView)

        titleStackView.addArrangedSubview(formTypeLabel)
        formTypeLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        titleStackView.addArrangedSubview(titleLabel)
        outerStackView.addArrangedSubview(titleStackView)

        outerStackView.addArrangedSubview(formNameLabel)
        outerStackView.addArrangedSubview(descriptionLabel)
        outerStackView.addArrangedSubview(dateLabel)

        NSLayoutConstraint.activate([

            container.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            container.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 10),
            container.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -10),


            indicatorView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
            indicatorView.leftAnchor.constraint(equalTo: container.layoutMarginsGuide.leftAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 4),

            outerStackView.topAnchor.constraint(equalTo: container.layoutMarginsGuide.topAnchor),
            outerStackView.leftAnchor.constraint(equalTo: indicatorView.layoutMarginsGuide.leftAnchor, constant: 5),
            outerStackView.rightAnchor.constraint(equalTo: container.layoutMarginsGuide.rightAnchor),
            outerStackView.bottomAnchor.constraint(equalTo: container.layoutMarginsGuide.bottomAnchor),
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

        if caseStatus.lastUpdatedFormatted.isEmpty {
            dateLabel.text = ""
        } else {
            dateLabel.text = "\(caseStatus.lastUpdatedFormatted) • \(caseStatus.lastUpdatedRelativeDaysFormatted)"
        }

        setNeedsLayout()
    }
}
