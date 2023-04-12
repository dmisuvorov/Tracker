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
        trackersViewController.router = self
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        trackersNavigationController.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "TrackerTabIcon"), tag: 0)
        trackersNavigationController.navigationBar.prefersLargeTitles = true

        let statisticsViewController = StatisticsViwController()
        let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
        statisticsNavigationController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "StatisticsTabIcon"), tag: 1)

        
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [trackersNavigationController, statisticsNavigationController]
        self.window.rootViewController = tabBarController
    }
    
    func createNewTrackFirstStep(parentVC: UIViewController) {
        let createTrackerTypeViewController = CreateTrackerTypeViewController()
        createTrackerTypeViewController.router = self
        let createNewTrackNavigationViewController = UINavigationController()
        
        let createNewTrackNavigationBarAppearence = UINavigationBarAppearance()
        createNewTrackNavigationBarAppearence.configureWithOpaqueBackground()
        createNewTrackNavigationBarAppearence.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        createNewTrackNavigationBarAppearence.shadowColor = nil
        createNewTrackNavigationBarAppearence.shadowImage = nil
        createNewTrackNavigationViewController.navigationBar.standardAppearance = createNewTrackNavigationBarAppearence
        
        parentVC.present(createNewTrackNavigationViewController, animated: true)
        createNewTrackNavigationViewController.pushViewController(createTrackerTypeViewController, animated: true)
    }
    
    func createNewTrackSecondStep(trackerType: TrackerType, parentNavigationController: UINavigationController) {
        let createTrackerViewController = CreateTrackerViewController()
        createTrackerViewController.trackerType = trackerType
        createTrackerViewController.router = self
        parentNavigationController.pushViewController(createTrackerViewController, animated: true)
    }
    
    func confugureNewTrackSchedule(parentNavigationController: UINavigationController) {
        let scheduleViewController = ScheduleViewController()
        parentNavigationController.pushViewController(scheduleViewController, animated: true)
    }
}
