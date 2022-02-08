//
//  NetworkProvider.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

protocol NetworkProvider {
	@available(iOS 15.0.0, *)
	func fetch() async throws -> Exercise
	func fetchSync() throws -> Exercise
}
