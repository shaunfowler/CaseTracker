//
//  DetailGroupView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-03-05.
//

import UIKit

class DetailGroupView: UIView {

    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()

    private var noteLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .caption2)
        label.numberOfLines = 0
        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.backgroundColor = .tertiarySystemFill
        stackView.layer.cornerRadius = 5
        return stackView
    }()

    var title: String = "" {
        didSet {
            titleLabel.text = title.uppercased()
        }
    }

    var note: String = "" {
        didSet {
            noteLabel.text = note
        }
    }

    var spacing: CGFloat = UIStackView.spacingUseDefault {
        didSet {
            stackView.spacing = spacing
        }
    }

    public func addDetailView(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(titleLabel)
        addSubview(noteLabel)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: stackView.layoutMarginsGuide.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            noteLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            noteLabel.leftAnchor.constraint(equalTo: stackView.layoutMarginsGuide.leftAnchor),
            noteLabel.rightAnchor.constraint(equalTo: rightAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
