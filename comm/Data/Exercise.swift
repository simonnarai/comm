//
//  Exercise.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

struct Exercise: Codable {
	let account: Account
	let transactions: [Transaction]
	let pending: [Transaction]
	let atms: [ATM]
}
