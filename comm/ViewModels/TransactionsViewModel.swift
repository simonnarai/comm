//
//  TransactionViewModel.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

final class TransactionsViewModel {

	private let networkProvider: NetworkProvider

	public private(set) var account: Account?
	private var atms: [ATM] = []
	private var transactions: [Date: [Transaction]] = [:]
	private var transactionKeys: [Date] = []

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

//	Removed in favour of daysAgo, kept commented to show modern API usage
//	private let relativeDateFormatter: RelativeDateTimeFormatter = {
//		let formatter = RelativeDateTimeFormatter()
//		formatter.dateTimeStyle = .named
//		return formatter
//	}()

	init(networkProvider: NetworkProvider) {
		self.networkProvider = networkProvider
	}

	@available(iOS 15.0.0, *)
	func fetch() async throws {
		let exercise = try await networkProvider.fetch()
		afterFetchSetup(withExercise: exercise)
	}

	func fetch() throws {
		let exercise = try networkProvider.fetchSync()
		afterFetchSetup(withExercise: exercise)
	}

	private func afterFetchSetup(withExercise exercise: Exercise) {
		account = exercise.account
		atms = exercise.atms

		let unsortedTransactions = mapTransactions(transactions: exercise.transactions, pendingTransactions: exercise.pending)

		transactions = sortTransactions(unsortedTransactions: unsortedTransactions)
		transactionKeys = transactions.keys.sorted(by: >)
	}

	private func mapTransactions(transactions: [Transaction], pendingTransactions: [Transaction]) -> [Transaction] {
		var mappedTransactions = transactions.map { Transaction($0) }
		mappedTransactions.append(contentsOf: pendingTransactions.map { Transaction($0, isPending: true) })
		return mappedTransactions
	}

	private func sortTransactions(unsortedTransactions: [Transaction]) -> [Date: [Transaction]] {
		var sortedTransactions = [Date: [Transaction]]()
		for transaction in unsortedTransactions {
			let date = Date.stripTime(fromDate: transaction.effectiveDate)
			if sortedTransactions[date] == nil {
				sortedTransactions[date] = []
			}
			sortedTransactions[date]?.append(transaction)
			sortedTransactions[date]?.sort { $0.effectiveDate > $1.effectiveDate }
		}
		return sortedTransactions
	}

	func getTransactionsCount() -> Int {
		transactions.count
	}

	func getTransactionDate(forSection section: Int) -> Date {
		transactionKeys[section]
	}

	func getTransactionCount(forSection section: Int) -> Int {
		transactionKeys.count == 0 ? 0 : transactions[transactionKeys[section]]?.count ?? 0
	}

	func getTransaction(indexPath: IndexPath) -> Transaction? {
		transactionKeys.count == 0 ? nil : transactions[transactionKeys[indexPath.section]]?[indexPath.row]
	}

	func getATM(forId id: String) -> ATM? {
		atms.first(where: { $0.id == id })
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

	func projectedSpend() -> Decimal {
		let cal = Calendar.current
		guard let daySpan = cal.dateComponents([.day], from: transactionKeys.last ?? Date(), to: transactionKeys.first ?? Date()).day, daySpan > 0 else { return 0 }

		var spendTotal: Decimal = 0

		for key in transactionKeys {
			if let transactions = transactions[key] {
				for transaction in transactions where transaction.amount < 0 {
					spendTotal += transaction.amount
				}
			}
		}

		return abs((spendTotal / Decimal(daySpan)) * 14)
	}
}
