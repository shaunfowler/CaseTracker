//
//  CaseCell.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-12.
//

import UIKit

class CaseListCell: UICollectionViewListCell {
    static let reuseId = "CaseListCell"

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
