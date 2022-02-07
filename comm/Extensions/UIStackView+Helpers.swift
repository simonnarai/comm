//
//  UIStackView+Helpers.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

extension UIStackView {

	/// Convenience initializer to set frequently used properties axis and spacing
	convenience init(axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat = 0.0, distribution: UIStackView.Distribution = .fill) {
		self.init()
		self.axis = axis
		self.spacing = spacing
		self.distribution = distribution
	}

	/// Add multiple arranged subviews in a single call
	func addArrangedSubviews(_ subviews: UIView...) {
		for subview in subviews {
			addArrangedSubview(subview)
		}
	}
}
