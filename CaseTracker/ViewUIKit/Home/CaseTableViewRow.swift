//
//  CaseTableViewRow.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import Foundation
import UIKit

class CaseTableViewRow: UITableViewCell {

    @IBOutlet var containerView: UIView!
    @IBOutlet var indicator: UIView!
    @IBOutlet var formType: UILabel!
    @IBOutlet var receiptNumber: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var lastUpdated: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        selectionStyle = .none
        indicator.layer.cornerRadius = 2
        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor(named: "CaseRowShadowColor")?.cgColor
        containerView.layer.shadowRadius = 8.0
        containerView.layer.shadowOpacity = 1
    }
}
