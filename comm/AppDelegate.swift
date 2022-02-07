//
//  AppDelegate.swift
//  comm
//
//  Created by Simon on 7/2/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)

		let transactionsViewController = TransactionsViewController()
		transactionsViewController.title = NSLocalizedString("Account Details", comment: "")
		let navigationController = UINavigationController(rootViewController: transactionsViewController)

		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		return true
	}
}
