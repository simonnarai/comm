//
//  TransactionCell.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionCell: UITableViewCell {

	private var rawDescriptionString = String()

	private let atmImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(fromAsset: .findUsIcon))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel(font: .systemFont(ofSize: 14, weight: .light))
		label.numberOfLines = 3
		label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		return label
	}()

	private let amountLabel = UILabel(font: .systemFont(ofSize: 15, weight: .medium))

	private let stack: UIStackView = {
		let stack = UIStackView(spacing: 8, distribution: .equalSpacing)
		stack.isLayoutMarginsRelativeArrangement = true
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 2, leading: 16, bottom: 2, trailing: 16)
		return stack
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	private func setupUI() {
		addSubviews(stack)

		stack.fillSuperview()
		stack.addArrangedSubviews(atmImageView, descriptionLabel, UIView(), amountLabel)
	}

	func setup(description: String, amount: String, isATM: Bool = false) {
		rawDescriptionString = description
		descriptionLabel.setHTML(fromString: rawDescriptionString)
		amountLabel.text = amount
		atmImageView.isHidden = !isATM
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)

		if #available(iOS 13.0, *) {
			if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
				DispatchQueue.main.async {
					self.descriptionLabel.attributedText = nil
					self.descriptionLabel.setHTML(fromString: self.rawDescriptionString)
				}
			}
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
