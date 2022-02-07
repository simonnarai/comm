//
//  FindUsViewModel.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit
import CoreLocation

final class FindUsViewModel {

	public private(set) var atmLocation = CLLocation()
	public private(set) var atmName = ""
	public private(set) var atmAddress = ""

	func setup(atm: ATM) {
		atmLocation = CLLocation(latitude: atm.location.lat, longitude: atm.location.lng)
		atmName = atm.name
		atmAddress = atm.address
	}
}
