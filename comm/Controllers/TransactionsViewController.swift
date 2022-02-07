//
//  AccountDetailsViewController.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionsViewController: UITableViewController {

	private let viewModel = TransactionsViewModel()

	private let cellHeight: CGFloat = 56
	private let headerHeight: CGFloat = 26

	private let accountDetailsHeader = AccountDetailsHeader()

	private let activityIndicator = UIActivityIndicatorView()

	private let transactionCellIdentifier = "TransactionCell"
	private let transactionHeaderIdentifier = "TransactionHeader"

	private let jsonURL = "https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1"

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		Task {
			await viewModel.fetchTransactions(from: jsonURL)

			if let account = viewModel.account {
				accountDetailsHeader.setup(
					accountName: account.accountName,
					accountNumber: account.accountNumber,
					availableFunds: viewModel.currencyString(account.available),
					accountBalance: viewModel.currencyString(account.balance))
			}

			tableView.reloadData()
			activityIndicator.stopAnimating()
		}
	}

	private func setupUI() {
		title = NSLocalizedString("Account Details", comment: "")

		tableView.register(TransactionCell.self, forCellReuseIdentifier: transactionCellIdentifier)
		tableView.register(TransactionHeader.self, forHeaderFooterViewReuseIdentifier: transactionHeaderIdentifier)

		tableView.sectionHeaderTopPadding = 0

		tableView.tableHeaderView = accountDetailsHeader

		tableView.addSubviews(activityIndicator)
		activityIndicator.centerAlignInSuperview()
		activityIndicator.style = .large
		activityIndicator.startAnimating()
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.getTransactionsCount()
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.getTransactionCount(forSection: section)
	}

	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return headerHeight
	}

	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: transactionHeaderIdentifier) as? TransactionHeader {
			let date = viewModel.getTransactionDate(forSection: section)
			header.setup(date: viewModel.dateString(date), daysAgo: viewModel.relativeDateString(date))
			return header
		}
		fatalError("Could not dequeueReusableHeaderFooterView")
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeight
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier, for: indexPath) as? TransactionCell {
			if let transaction = viewModel.getTransaction(indexPath: indexPath) {
				cell.setup(description: viewModel.description(for: transaction), amount: viewModel.currencyString(transaction.amount), isATM: transaction.isATM)
				return cell
			}
		}
		fatalError("Could not dequeueReusableCell")
	}

	override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		if let transaction = viewModel.getTransaction(indexPath: indexPath), transaction.isATM {
			return indexPath
		}
		return nil
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let transaction = viewModel.getTransaction(indexPath: indexPath), transaction.isATM {
			if let atm = viewModel.getATM(forId: transaction.atmId ?? "") {
				let findUsMapViewController = FindUsMapViewController()
				findUsMapViewController.setup(atm: atm)
				navigationController?.pushViewController(findUsMapViewController, animated: true)
			}
		}
	}
}
