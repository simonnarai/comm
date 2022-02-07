//
//  Transaction.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

struct Transaction: Codable {
	let id: String
	let effectiveDate: Date
	let description: String
	let amount: Decimal
	let atmId: String?
	var isPending: Bool? = false

	var isATM: Bool {
		return atmId != nil
	}

	init(_ original: Transaction, isPending: Bool = false) {
		id = original.id
		effectiveDate = original.effectiveDate
		description = original.description
		amount = original.amount
		atmId = original.atmId
		self.isPending = isPending
	}
}
