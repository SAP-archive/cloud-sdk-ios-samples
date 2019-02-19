//
//  AppDelegate.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tableViewController = TableViewController() as TableViewController
        let navigationController = UINavigationController(rootViewController: tableViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barTintColor = UIColor(displayP3Red: 0, green: 191/255, blue: 255/255, alpha: 1)
        let navbarTextColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor: navbarTextColor]
        UINavigationBar.appearance().titleTextAttributes = textAttributes
        navigationController.navigationBar.tintColor = navbarTextColor
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }

}

