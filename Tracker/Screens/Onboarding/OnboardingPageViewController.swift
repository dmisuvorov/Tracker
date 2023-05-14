//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 12.05.2023.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    var router: ApplicationFlowRouter? = nil
    
    private var pages: [UIViewController] = [
        OnboardingViewController(model: OnboardingModel(text: "Отслеживайте только\nто, что хотите", image: "Onboarding1")),
        OnboardingViewController(model: OnboardingModel(text: "Даже если это\nне литры воды и йога", image: "Onboarding2")),
    ]

    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        pageControl.pageIndicatorTintColor = UIColor.dsColor(dsColor: DSColor.dayBlack).withAlphaComponent(0.3)
        pageControl.numberOfPages = pages.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        button.setTitle("Вот это технологии!", for: UIControl.State.normal)
        button.setTitleColor(UIColor.dsColor(dsColor: DSColor.dayWhite), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonClick), for: .touchUpInside)

        return button
    }()
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey: Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: navigationOrientation,
            options: options
        )
    }

    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePages()
        configureUI()
    }

    @objc func onButtonClick() {
        router?.mainScreen()
    }
    
    private func configurePages() {
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        }
    }
    
    private func configureUI() {
        view.addSubview(pageControl)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 60),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24)
        ])
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentPageIndex = pages.firstIndex(of: viewController) else { return nil }
        let pageBefore = pages[(currentPageIndex - 1 + pages.count) % pages.count]
        return pageBefore
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentPageIndex = pages.firstIndex(of: viewController) else { return nil }
        let pageAfter = pages[(currentPageIndex + 1) % pages.count]
        return pageAfter
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
