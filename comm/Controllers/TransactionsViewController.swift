//
//  AccountDetailsViewController.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionsViewController: UITableViewController {

	private let viewModel = TransactionsViewModel(networkProvider: NetworkFetcher())

	private let cellHeight: CGFloat = 56
	private let headerHeight: CGFloat = 26

	private let accountDetailsHeader = AccountDetailsHeader()

	private let activityIndicator = UIActivityIndicatorView()

	private let transactionCellIdentifier = "TransactionCell"
	private let transactionHeaderIdentifier = "TransactionHeader"

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchData()
	}

	private func setupUI() {
		title = NSLocalizedString("Account Details", comment: "")

		tableView.register(TransactionCell.self, forCellReuseIdentifier: transactionCellIdentifier)
		tableView.register(TransactionHeader.self, forHeaderFooterViewReuseIdentifier: transactionHeaderIdentifier)

		if #available(iOS 15.0, *) {
			tableView.sectionHeaderTopPadding = 0
		}

		tableView.tableHeaderView = accountDetailsHeader

		tableView.addSubviews(activityIndicator)
		activityIndicator.centerAlignInSuperview()
		if #available(iOS 13.0, *) {
			activityIndicator.style = .large
		}
		activityIndicator.startAnimating()
	}

	private func fetchData() {
		if #available(iOS 15.0, *) {
			Task {
				do {
					try await viewModel.fetch()
					afterFetchSetup()
				} catch {
					showError()
				}
			}
		} else {
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				do {
					try self?.viewModel.fetch()
					DispatchQueue.main.async {
						self?.afterFetchSetup()
					}
				} catch {
					DispatchQueue.main.async {
						self?.showError()
					}
				}
			}
		}
	}

	private func afterFetchSetup() {
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

	private func showError(title: String = NSLocalizedString("Something Went Wrong", comment: ""), message: String = NSLocalizedString("Please try again later", comment: "")) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { [weak self] _ in self?.activityIndicator.stopAnimating() }))
		present(alert, animated: true)
	}

// MARK: Table View
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
		return nil
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellHeight
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier, for: indexPath) as? TransactionCell,
		   let transaction = viewModel.getTransaction(indexPath: indexPath) {
			cell.setup(description: viewModel.description(for: transaction), amount: viewModel.currencyString(transaction.amount), isATM: transaction.isATM)
			return cell
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
		if let transaction = viewModel.getTransaction(indexPath: indexPath),
		   transaction.isATM,
		   let atm = viewModel.getATM(forId: transaction.atmId ?? "") {
			let findUsMapViewController = FindUsMapViewController()
			findUsMapViewController.setup(atm: atm)
			navigationController?.pushViewController(findUsMapViewController, animated: true)
		}
	}
}
