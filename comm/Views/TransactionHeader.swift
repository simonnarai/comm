//
//  TransactionHeader.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionHeader: UITableViewHeaderFooterView {

	private let dateLabel = UILabel(font: .systemFont(ofSize: 14, weight: .semibold), textColor: .black)

	private let daysAgoLabel = UILabel(font: .systemFont(ofSize: 14, weight: .semibold), textColor: .black)

	private let stack: UIStackView = {
		let stack = UIStackView(spacing: 10, distribution: .equalSpacing)
		stack.alignment = .center
		stack.backgroundColor = UIColor(fromAsset: .transactionHeaderBackground)
		stack.isLayoutMarginsRelativeArrangement = true
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
		return stack
	}()

	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	private func setupUI() {
		addSubviews(stack)

		stack.fillSuperview()
		stack.addArrangedSubviews(dateLabel, daysAgoLabel)
	}

	func setup(date: String, daysAgo: String) {
		dateLabel.text = date
		daysAgoLabel.text = daysAgo
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
