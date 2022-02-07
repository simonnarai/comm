//
//  UIColor+Assets.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

extension UIColor {

	enum AssetCatalogue: String {
		case accountDetailsDivider
		case accountDetailsHeaderBackground
		case accountText
		case greyBackground
		case greyText
		case transactionHeaderBackground
	}

	/// Convenience init to return a color defined in the asset catalogue
	convenience init?(fromAsset asset: AssetCatalogue) {
		self.init(named: asset.rawValue)
	}
}
