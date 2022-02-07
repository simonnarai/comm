//
//  MKMapView+Helpers.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import MapKit

extension MKMapView {

	/// Center the map view to a specified location
	func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
		let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
		setRegion(coordinateRegion, animated: true)
	}
}
