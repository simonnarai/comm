//
//  CommTests.swift
//  commTests
//
//  Created by Simon on 7/2/22.
//

import XCTest
@testable import comm

class CommTests: XCTestCase {

	let account = Account(accountName: "Test Account", accountNumber: "123456 7890 1234", available: 505.55, balance: 525.55)
	let transactions: [Transaction] = [
		Transaction(id: "1", effectiveDate: Date(), description: "First Test Transaction", amount: -12.50, atmId: nil),
		Transaction(id: "2", effectiveDate: Date(), description: "Second Test Transaction", amount: -100.50, atmId: nil)
	]
	let pending: [Transaction] = [
		Transaction(id: "1", effectiveDate: Date(), description: "A Pending Transaction", amount: -56.99, atmId: nil),
		Transaction(id: "2", effectiveDate: Date(), description: "Another Pending Transaction", amount: -19.00, atmId: nil)
	]
	let atms: [ATM] = [
	]

	var mockExercise: Exercise?

    override func setUpWithError() throws {
        mockExercise = Exercise(account: account, transactions: transactions, pending: pending, atms: atms)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testFetchBadUrl() async throws {
		let badUrl = "https:\\www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1"

		let viewModel = TransactionsViewModel(networkProvider: NetworkFetcher(jsonUrl: badUrl))

		try? await viewModel.fetch()

		XCTAssertNil(viewModel.account)
		XCTAssertEqual(viewModel.getTransactionsCount(), 0)
		XCTAssertEqual(viewModel.getTransactionCount(forSection: 0), 0)
		XCTAssertNil(viewModel.getTransaction(indexPath: IndexPath(row: 0, section: 0)))
	}

    func testFetchTransactions() async throws {
		let goodUrl = "https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1"

		let viewModel = TransactionsViewModel(networkProvider: NetworkFetcher(jsonUrl: goodUrl))

		try? await viewModel.fetch()

		XCTAssertEqual(viewModel.account?.accountName, "Complete Access")
		XCTAssertEqual(viewModel.getTransactionsCount(), 13)
		XCTAssertEqual(viewModel.getTransactionCount(forSection: 0), 2)
		XCTAssertEqual(viewModel.getTransaction(indexPath: IndexPath(item: 0, section: 0))?.amount, 12.0)
    }

	func testProjectedSpend() throws {
		guard let exercise = mockExercise else {
			return
		}

		let viewModel = TransactionsViewModel(networkProvider: MockFetcher(exercise: exercise))

		XCTAssertEqual(viewModel.projectedSpend(), 0)
	}

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
