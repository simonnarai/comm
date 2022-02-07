//
//  UIView+Helpers.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

extension UIView {

	/// Add multiple subviews in a single call (and set translatesAutoresizingMaskIntoConstraints to false)
	func addSubviews(_ subviews: UIView...) {
		for subview in subviews {
			addSubview(subview)
			subview.translatesAutoresizingMaskIntoConstraints = false
		}
	}

	/// Set all four edge constraints to be equal to the superview
	func fillSuperview() {
		if let superview = superview {
			NSLayoutConstraint.activate([topAnchor.constraint(equalTo: superview.topAnchor),
										 bottomAnchor.constraint(equalTo: superview.bottomAnchor),
										 leadingAnchor.constraint(equalTo: superview.leadingAnchor),
										 trailingAnchor.constraint(equalTo: superview.trailingAnchor)])
		} else {
			assertionFailure("fillSuperview called on \(description) but no superview was found.")
		}
	}

	/// Set all four edge constraints to be equal to the superview, less constant insets
	func fillSuperview(withInsets insets: NSDirectionalEdgeInsets) {
		if let superview = superview {
			NSLayoutConstraint.activate(
				[topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
				 bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
				 leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading),
				 trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.trailing)])
		} else {
			assertionFailure("fillSuperview called on \(description) but no superview was found.")
		}
	}

	/// Set top, bottom and leading edge constraints to be equal to the superview, with the trailing constraint to be less than or equal to, to left align the view within the superview
	func leftAlignInSuperview() {
		if let superview = superview {
			NSLayoutConstraint.activate([topAnchor.constraint(equalTo: superview.topAnchor),
										 bottomAnchor.constraint(equalTo: superview.bottomAnchor),
										 leadingAnchor.constraint(equalTo: superview.leadingAnchor),
										 trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor)])
		} else {
			assertionFailure("leftAlignInSuperview called on \(description) but no superview was found.")
		}
	}

	/// Set X and Y center constraints to be equal to the superview, to center align the view with the superview
	func centerAlignInSuperview() {
		if let superview = superview {
			NSLayoutConstraint.activate([centerXAnchor.constraint(equalTo: superview.centerXAnchor),
										 centerYAnchor.constraint(equalTo: superview.centerYAnchor)])
		} else {
			assertionFailure("centerAlignInSuperview called on \(description) but no superview was found.")
		}
	}
}
