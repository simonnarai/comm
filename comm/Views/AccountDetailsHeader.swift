//
//  AccountDetailsHeader.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class AccountDetailsHeader: UIView {

	private let headerHeight = 160.0

	private let imageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(fromAsset: .accountsImageTransactional))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	private let accountNameLabel = UILabel(
		text: " ",
		font: UIFont(name: "HelveticaNeue-Light", size: 22.0),
		textColor: UIColor(fromAsset: .accountText)
	)

	private let accountNumberLabel = UILabel(textColor: UIColor(fromAsset: .greyText))

	private let availableFundsLabel = UILabel(
		text: NSLocalizedString("Available funds", comment: ""),
		textColor: UIColor(fromAsset: .greyText)
	)

	private let availableFundsValueLabel = UILabel()

	private let accountBalanceLabel = UILabel(
		text: NSLocalizedString("Account balance", comment: ""),
		textColor: UIColor(fromAsset: .greyText)
	)

	private let accountBalanceValueLabel = UILabel(textColor: UIColor(fromAsset: .greyText))

	private let outerStack: UIStackView = {
		let stack = UIStackView(axis: .vertical, spacing: 1, distribution: .fillEqually)
		stack.backgroundColor = UIColor(fromAsset: .accountDetailsDivider)
		return stack
	}()

	private let upperStack: UIStackView = {
		let stack = UIStackView(spacing: 10)
		if #available(iOS 13.0, *) {
			stack.backgroundColor = .systemBackground
		} else {
			stack.backgroundColor = .white
		}
		stack.isLayoutMarginsRelativeArrangement = true
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
		return stack
	}()

	private let upperLabelStack = UIStackView(axis: .vertical, spacing: 2)

	private let lowerView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(fromAsset: .greyBackground)
		return view
	}()

	private let lowerStack: UIStackView = {
		let stack = UIStackView(axis: .vertical, spacing: 2, distribution: .fillEqually)
		stack.backgroundColor = UIColor(fromAsset: .greyBackground)
		stack.isLayoutMarginsRelativeArrangement = true
		stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 6, leading: 68, bottom: 6, trailing: 10)
		return stack
	}()

	private let availableFundsStack = UIStackView(spacing: 20, distribution: .equalSpacing)
	private let accountBalanceStack = UIStackView(spacing: 20, distribution: .equalSpacing)

	override init(frame: CGRect = .zero) {
		super.init(frame: frame)
		self.frame = CGRect(x: 0, y: 0, width: frame.width, height: headerHeight)
		setupUI()
	}

	private func setupUI() {
		backgroundColor = UIColor(fromAsset: .accountDetailsHeaderBackground)

		addSubviews(outerStack)

		outerStack.fillSuperview(withInsets: NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 16))
		outerStack.addArrangedSubviews(upperStack, lowerStack)

		upperStack.addArrangedSubviews(imageView, upperLabelStack)
		upperLabelStack.addArrangedSubviews(accountNameLabel, accountNumberLabel)

		lowerStack.addArrangedSubviews(availableFundsStack, accountBalanceStack)
		availableFundsStack.addArrangedSubviews(availableFundsLabel, availableFundsValueLabel)
		accountBalanceStack.addArrangedSubviews(accountBalanceLabel, accountBalanceValueLabel)

		imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
	}

	func setup(accountName: String, accountNumber: String, availableFunds: String, accountBalance: String) {
		accountNameLabel.text = accountName
		accountNumberLabel.text = accountNumber
		availableFundsValueLabel.text = availableFunds
		accountBalanceValueLabel.text = accountBalance
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
