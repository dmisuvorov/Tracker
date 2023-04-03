//
//  ApplicationFlowRouter.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//
import UIKit

final class ApplicationFlowRouter {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let trackersViewController = TrackersViewController()
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackerTabIcon"), tag: 0)

        let statisticsViewController = StatisticsViwController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabIcon"), tag: 1)

        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [trackersNavigationController, statisticsNavigationController]
        self.window.rootViewController = tabBarController
    }
}
