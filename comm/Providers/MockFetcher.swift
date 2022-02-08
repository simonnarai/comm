//
//  MockManager.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

struct MockManager: NetworkProvider {

	let exercise: Exercise

	@available(iOS 15.0.0, *)
	func fetch() async throws -> Exercise {
		return exercise
	}

	func fetchSync() throws -> Exercise {
		return exercise
	}

	init(exercise: Exercise) {
		self.exercise = exercise
	}
}
