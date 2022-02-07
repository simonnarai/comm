//
//  UIImage+Assets.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

extension UIImage {

	enum AssetCatalogue: String {
		case accountsImageTransactional
		case findUsAnnotationIconATM
		case findUsIcon
	}

	/// Convenience init to return an image defined in the asset catalogue
	convenience init?(fromAsset asset: AssetCatalogue) {
		self.init(named: asset.rawValue)
	}
}
