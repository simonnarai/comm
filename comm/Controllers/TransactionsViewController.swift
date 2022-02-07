//
//  AccountDetailsViewController.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionsViewController: UITableViewController {

	private var viewModel = TransactionsViewModel()

	private let cellHeight: CGFloat = 56
	private let headerHeight: CGFloat = 26

	private let accountDetailsHeader = AccountDetailsHeader()

	private let activityIndicator = UIActivityIndicatorView()

	private let transactionCellString = "TransactionCell"
	private let transactionHeaderString = "TransactionHeader"

	private let jsonURL = "https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1"

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		Task {
			await viewModel.fetchTransactions(from: jsonURL)

			activityIndicator.stopAnimating()

			if let account = viewModel.account {
				accountDetailsHeader.setup(
					accountName: account.accountName,
					accountNumber: account.accountNumber,
					availableFunds: viewModel.currencyString(account.available),
					accountBalance: viewModel.currencyString(account.balance))
			}

			tableView.reloadData()
		}
	}

	private func setupUI() {
		tableView.register(TransactionCell.self, forCellReuseIdentifier: transactionCellString)
		tableView.register(TransactionHeader.self, forHeaderFooterViewReuseIdentifier: transactionHeaderString)

		tableView.sectionHeaderTopPadding = 0

		tableView.tableHeaderView = accountDetailsHeader

		tableView.addSubviews(activityIndicator)
		activityIndicator.centerAlignInSuperview()
		activityIndicator.style = .large
		activityIndicator.startAnimating()
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.transactions.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.transactions[viewModel.transactionKeys[section]]?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: transactionHeaderString) as? TransactionHeader {
			let date = viewModel.transactionKeys[section]
			header.setup(date: viewModel.dateString(date), daysAgo: viewModel.relativeDateString(date))
			return header
		}
		fatalError("Could not dequeueReusableHeaderFooterView")
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeight
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellString, for: indexPath) as? TransactionCell {
			if let transaction = viewModel.transactions[viewModel.transactionKeys[indexPath.section]]?[indexPath.row] {
				cell.setup(description: viewModel.description(for: transaction), amount: viewModel.currencyString(transaction.amount), isATM: transaction.isATM)
				return cell
			}
		}
		fatalError("Could not dequeueReusableCell")
	}
}
