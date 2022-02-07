//
//  UILabel+Helpers.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

extension UILabel {

	/// Convenience initializer to set frequently used properties text and textStyle
	convenience init(text: String = "", font: UIFont? = nil, textColor: UIColor? = nil) {
		self.init()
		self.text = text
		self.font = font ?? .preferredFont(forTextStyle: .body)
		if #available(iOS 13.0, *) {
			self.textColor = textColor ?? .label
		} else {
			self.textColor = textColor ?? .black
		}
	}

	/// Set attributedText from html, matching system font and font size
	func setHTML(fromString htmlText: String) {
		let textWithFontSpan = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize); color: \(self.textColor.hexString())\">%@</span>", htmlText)

		if let data = textWithFontSpan.data(using: .utf8, allowLossyConversion: true) {
			if let attributedString = try? NSAttributedString(
				data: data,
				options: [.documentType: NSAttributedString.DocumentType.html],
				documentAttributes: nil) {
				self.attributedText = attributedString
			}
		}
	}
}
