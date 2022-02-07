//
//  TransactionViewModel.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionsViewModel {

	public private(set) var account: Account?
	public private(set) var atms = [ATM]()
	public private(set) var transactions = [Date: [Transaction]]()
	public private(set) var transactionKeys = [Date]()

	private let currencyFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.locale = .current
		formatter.numberStyle = .currency
		return formatter
	}()

	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.timeZone = .current
		formatter.dateFormat = "dd MMM yyyy"
		return formatter
	}()

	private let jsonDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.timeZone = .current
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}()

//	Removed in favour of dayAgo
//	private let relativeDateFormatter: RelativeDateTimeFormatter = {
//		let formatter = RelativeDateTimeFormatter()
//		formatter.dateTimeStyle = .named
//		return formatter
//	}()

	func fetchTransactions(from address: String) async {
		do {
			guard let url = URL(string: address) else {
				print("Invalid URL")
				return
			}
			let exercise: Exercise = try await URLSession.shared.decode(from: url, dateDecodingStrategy: .formatted(jsonDateFormatter))
			account = exercise.account
			atms = exercise.atms

			var unsortedTransactions = exercise.transactions.map { Transaction($0) }
			unsortedTransactions.append(contentsOf: exercise.pending.map { Transaction($0, isPending: true) })

			transactions = sortTransactions(rawTransactions: unsortedTransactions)
			transactionKeys = transactions.keys.sorted(by: >)
		} catch {
			print("Download error: \(error)")
		}
	}

	private func sortTransactions(rawTransactions: [Transaction]) -> [Date: [Transaction]] {
		var sortedTransactions = [Date: [Transaction]]()
		for transaction in rawTransactions {
			let date = Date.stripTime(fromDate: transaction.effectiveDate)
			if sortedTransactions[date] == nil {
				sortedTransactions[date] = []
			}
			sortedTransactions[date]?.append(transaction)
			sortedTransactions[date]?.sort { $0.effectiveDate > $1.effectiveDate }
		}
		return sortedTransactions
	}

	func currencyString(_ value: Decimal) -> String {
		currencyFormatter.string(from: value as NSNumber) ?? ""
	}

	func dateString(_ date: Date) -> String {
		dateFormatter.string(from: date)
	}

	func relativeDateString(_ date: Date) -> String {
		return date.daysAgo()
//		relativeDateFormatter.localizedString(for: date, relativeTo: Date())
	}

	func description(for transaction: Transaction) -> String {
		var description = transaction.description
		if let isPending = transaction.isPending, isPending {
			let pendingText = NSLocalizedString("PENDING", comment: "All-Caps")
			let wrappedText = "<b>\(pendingText): </b>"
			description = "\(wrappedText)\(transaction.description)"
		}
		return description
	}
}
