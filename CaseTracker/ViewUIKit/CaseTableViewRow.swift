//
//  CaseTableViewRow.swift
//  CaseTracker
//
//  Created by Fowler, Shaun on 2/20/22.
//

import Foundation
import UIKit

class CaseTableViewRow: UITableViewCell {

    @IBOutlet var indicator: UIView!
    @IBOutlet var formType: UILabel!
    @IBOutlet var receiptNumber: UILabel!
    @IBOutlet var status: UILabel!
    @IBOutlet var lastUpdated: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        indicator.layer.cornerRadius = 2
    }
}
