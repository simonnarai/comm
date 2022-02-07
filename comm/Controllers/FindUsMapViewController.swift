//
//  FindUsMapViewController.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit
import MapKit

final class FindUsMapViewController: UIViewController, MKMapViewDelegate {

	private let viewModel = FindUsViewModel()

	private let mapView = MKMapView()

	private let atmAnnotationString = "atmAnnotationString"

	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.delegate = self
		setupUI()
	}

	private func setupUI() {
		title = NSLocalizedString("ATM Location", comment: "")

		view = mapView

		if #available(iOS 13.0, *) {
			let barAppearance = UINavigationBarAppearance()
			barAppearance.configureWithDefaultBackground()
			navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
		}
	}

	func setup(atm: ATM) {
		viewModel.setup(atm: atm)

		let atmAnnotation = MKPointAnnotation()
		atmAnnotation.title = viewModel.atmName
		atmAnnotation.coordinate = viewModel.atmLocation.coordinate
		mapView.addAnnotation(atmAnnotation)

		mapView.centerToLocation(viewModel.atmLocation, regionRadius: 500)
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is MKPointAnnotation else { return nil }

		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: atmAnnotationString)

		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: atmAnnotationString)
			annotationView?.image = UIImage(fromAsset: .findUsAnnotationIconATM)
			annotationView?.canShowCallout = true
		} else {
			annotationView?.annotation = annotation
		}

		let subtitleView = UILabel(
			text: viewModel.atmAddress,
			font: .systemFont(ofSize: 14, weight: .light)
		)
		annotationView?.detailCalloutAccessoryView = subtitleView

		return annotationView
	}
}
