//
//  Account.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

struct Account: Codable {
	let accountName: String
	let accountNumber: String
	let available: Decimal
	let balance: Decimal
}
