//
//  Date+Helpers.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import Foundation

extension Date {

	/// Strip time components from a Date
	static func stripTime(fromDate: Date) -> Date {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
			fatalError("Failed to strip time from Date object")
		}
		return date
	}

	/// Get a string displaying how many days ago the date was compared with Today
	func daysAgo() -> String {
		let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
		if diff == 0 {
			return NSLocalizedString("Today", comment: "")
		} else if diff == 1 {
			return NSLocalizedString("1 Day Ago", comment: "")
		}
		return String(format: NSLocalizedString("%d Days Ago", comment: ""), diff)
	}
}
