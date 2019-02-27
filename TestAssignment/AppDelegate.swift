//
//  AppDelegate.swift
//  TestAssignment
//
//  Created by Andrey Volobuev on 2/27/19.
//  Copyright © 2019 blob8129. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard NSClassFromString("XCTestCase") == nil else { return true }
        window?.rootViewController = Builder().build()
        window?.makeKeyAndVisible()
        return true
    }

}

