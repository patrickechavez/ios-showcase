//
//  UIView+Ext.swift
//  ios-showcase
//
//  Created by John Patrick Echavez on 12/14/24.
//

import UIKit

extension UIView {
    func configureSubview(_ subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIStackView {
    func configureAsHorizontalStack(spacing: CGFloat = 8) {
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = spacing
    }
}
