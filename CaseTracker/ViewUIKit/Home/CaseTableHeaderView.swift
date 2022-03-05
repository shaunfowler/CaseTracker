//
//  CaseTableHeaderView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 3/4/22.
//

import UIKit

class CaseTableHeaderView: UITableViewHeaderFooterView {

    enum Constants {
        static let reuseId = "case-header-cell"
    }

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
