//
//  ApplicationFlowRouter.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//
import UIKit

final class ApplicationFlowRouter {
    private let launchedBeforeKey = "launchedBefore"
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if launchedBefore() {
            mainScreen()
            return
        }
        onboarding()
        UserDefaults.standard.set(true, forKey: launchedBeforeKey)
    }
    
    func onboarding() {
        let onboardingViewController = OnboardingPageViewController()
        onboardingViewController.router = self
        self.window.rootViewController = onboardingViewController
    }
    
    func mainScreen() {
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
        let createNewTrackNavigationViewController = UINavigationController(rootViewController: createTrackerTypeViewController)
        
        let createNewTrackNavigationBarAppearence = UINavigationBarAppearance()
        createNewTrackNavigationBarAppearence.configureWithOpaqueBackground()
        createNewTrackNavigationBarAppearence.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        createNewTrackNavigationBarAppearence.shadowColor = nil
        createNewTrackNavigationBarAppearence.shadowImage = nil
        createNewTrackNavigationViewController.navigationBar.standardAppearance = createNewTrackNavigationBarAppearence
        
        parentVC.present(createNewTrackNavigationViewController, animated: true)
    }
    
    func createNewTrackSecondStep(trackerType: TrackerType, parentNavigationController: UINavigationController) {
        let trackerDetailsViewController = TrackerDetailsViewController()
        trackerDetailsViewController.trackerType = trackerType
        trackerDetailsViewController.router = self
        parentNavigationController.pushViewController(trackerDetailsViewController, animated: true)
    }
    
    func confugureNewTrackerSchedule(
        selectedSchedule: Set<Day>,
        scheduleDelegate: ScheduleDelegate,
        parentNavigationController: UINavigationController
    ) {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.scheduleDelegate = scheduleDelegate
        scheduleViewController.selectedDays = selectedSchedule
        parentNavigationController.pushViewController(scheduleViewController, animated: true)
    }
    
    func confugureNewTrackerCategory(
        selectedCategory: TrackerCategory?,
        trackerCategoryDelegate: TrackerCategoryDelegate,
        parentNavigationController: UINavigationController
    ) {
        let trackerCategoryViewModel = TrackerCategoryViewModel(selectedCategory: selectedCategory)
        let trackerCategoryViewController = TrackerCategoryListViewController(viewModel: trackerCategoryViewModel)
        trackerCategoryViewController.trackerCategoryDelegate = trackerCategoryDelegate
        trackerCategoryViewController.router = self
        parentNavigationController.pushViewController(trackerCategoryViewController, animated: true)
    }
    
    func createNewTrackerCategory(
        trackerCategoryViewModel: TrackerCategoryViewModel,
        parentNavigationController: UINavigationController
    ) {
        let createTrackerCategoryViewController = CreateTrackerCategoryViewController(viewModel: trackerCategoryViewModel)
        parentNavigationController.pushViewController(createTrackerCategoryViewController, animated: true)
    }
    
    private func launchedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: launchedBeforeKey)
    }
}
