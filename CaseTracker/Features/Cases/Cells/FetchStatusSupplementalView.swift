//
//  FetchStatusSupplementalView.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-03-07.
//

import Foundation
import UIKit

class FetchStatusSupplementalView: UICollectionReusableView {

    static let reuseId = "FetchStatusSupplementalView"

    var text: String? {
        didSet {
            fetchStatusLabel.text = text
        }
    }

    private var fetchStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(fetchStatusLabel)
        NSLayoutConstraint.activate([
            fetchStatusLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            fetchStatusLabel.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            fetchStatusLabel.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
}
