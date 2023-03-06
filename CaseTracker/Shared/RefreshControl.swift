//
//  RefreshControl.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-03-04.
//

import UIKit

class RefreshControl: UIRefreshControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var label: UILabel = {
        let label = UILabel()
        label.text = "Refreshing..."
        label.backgroundColor = .systemBackground
        label.textAlignment = .center
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

//        backgroundColor = .red
//
//        addSubview(label)
//        label.frame = bounds
    }
}
