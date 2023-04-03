//
//  AppDelegate.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window =  UIWindow(frame: UIScreen.main.bounds)
        let appFlowRouter = ApplicationFlowRouter(window: window)
        appFlowRouter.start()
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }
}

