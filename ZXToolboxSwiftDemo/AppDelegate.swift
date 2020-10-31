//
//  AppDelegate.swift
//  ZXToolboxSwiftDemo
//
//  Created by xyz on 2020/10/24.
//  Copyright © 2020 xinyzhao. All rights reserved.
//

import UIKit

@_exported import ZXToolboxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "NaviController")
        window = UIWindow()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

}

