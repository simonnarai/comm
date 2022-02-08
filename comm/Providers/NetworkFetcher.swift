//
//  NetworkManager.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

struct NetworkFetcher: NetworkProvider {

	private let jsonURL: String

	private let jsonDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.locale = .current
		formatter.timeZone = .current
		formatter.dateFormat = "dd/MM/yyyy"
		return formatter
	}()

	@available(iOS 15.0.0, *)
	func fetch() async throws -> Exercise {
		guard let url = URL(string: jsonURL) else {
			throw URLError(.badURL)
		}
		guard let exercise: Exercise = try await URLSession.shared.decode(from: url, dateDecodingStrategy: .formatted(jsonDateFormatter)) else {
			throw URLError(.downloadDecodingFailedToComplete)
		}
		return exercise
	}

	func fetchSync() throws -> Exercise {
		guard let url = URL(string: jsonURL) else {
			throw URLError(.badURL)
		}
		guard let exercise: Exercise = try URLSession.shared.decode(from: url, dateDecodingStrategy: .formatted(jsonDateFormatter)) else {
			throw URLError(.downloadDecodingFailedToComplete)
		}
		return exercise
	}

	init(jsonUrl: String = "https://www.dropbox.com/s/tewg9b71x0wrou9/data.json?dl=1") {
		self.jsonURL = jsonUrl
	}
}
