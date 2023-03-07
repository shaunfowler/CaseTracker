//
//  CaseHistoryView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-03-02.
//

import UIKit

class HistoryStackView: UIStackView {

    private let timelineLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        spacing = 10
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        timelineLayer.path = UIBezierPath(roundedRect: CGRect(x: 14, y: 0, width: 2, height: frame.height), cornerRadius: 4).cgPath
        updateColors()
        layer.insertSublayer(timelineLayer, at: 0)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateColors()
    }

    func addHistoricalItem(status: String, color: UIColor) {
        let view = CaseHistoryItemView(status: status, color: color)
        super.addArrangedSubview(view)
    }

    private func updateColors() {
        timelineLayer.fillColor = UIColor.systemGray5.cgColor
    }
}

fileprivate class CaseHistoryItemView: UIView {

    var statusOrb: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.widthAnchor.constraint(equalToConstant: 10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return view
    }()

    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: UIFont.systemFontSize)
        return label
    }()

    init(status: String, color: UIColor) {
        statusOrb.backgroundColor = color
        statusLabel.text = status
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(statusOrb)
        addSubview(statusLabel)

        NSLayoutConstraint.activate([
            statusOrb.centerYAnchor.constraint(equalTo: statusLabel.centerYAnchor),
            statusOrb.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            statusOrb.rightAnchor.constraint(equalTo: statusLabel.leftAnchor, constant: -10),
            statusLabel.heightAnchor.constraint(equalTo: heightAnchor),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
}
