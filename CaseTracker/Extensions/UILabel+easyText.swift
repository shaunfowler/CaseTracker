//
//  UILabel+easyText.swift
//  CaseTracker
//
//  Created by Shaun Fowler on 2023-02-18.
//

import UIKit

extension UILabel {

    static func easyText(
        text: String,
        font: UIFont = .systemFont(ofSize: UIFont.systemFontSize),
        alignment: NSTextAlignment = .left,
        numberOfLines: Int = 0,
        color: UIColor? = nil
    ) -> Self {
        let label = Self(frame: .zero)
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = numberOfLines
        label.textAlignment = alignment
        return label
    }
}
