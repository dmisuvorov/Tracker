//
//  AppDelegate.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.03.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                assertionFailure(error.localizedDescription)
            }
        })
        return container
    }()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        AnalyticsService.shared.activate()
        let window =  UIWindow(frame: UIScreen.main.bounds)
        let appFlowRouter = ApplicationFlowRouter(window: window)
        appFlowRouter.start()
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }
}

