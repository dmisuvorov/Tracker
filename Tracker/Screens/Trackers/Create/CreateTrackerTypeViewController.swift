//
//  CreateTrackerTypeViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 07.04.2023.
//
import UIKit

final class CreateTrackerTypeViewController: UIViewController {
    var router: ApplicationFlowRouter? = nil
    
    private lazy var habitTrackerTypeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        button.setTitle("Привычка", for: UIControl.State.normal)
        button.setTitleColor(UIColor.dsColor(dsColor: DSColor.dayWhite), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onChoseHabitTracker), for: .touchUpInside)

        return button
    }()
    
    private lazy var irregularEventTrackerTypeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        button.setTitle("Нерегулярное событие", for: UIControl.State.normal)
        button.setTitleColor(UIColor.dsColor(dsColor: DSColor.dayWhite), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onChoseIrregularEventTracker), for: .touchUpInside)

        return button
    }()
    
    override func viewDidLoad() {
        title = "Создание трекера"
        configureUI()
    }
    
    @objc
    private func onChoseHabitTracker() {
        guard let navigationController = navigationController else { return }
        router?.createNewTrackSecondStep(trackerType: TrackerType.habit, parentNavigationController: navigationController)
    }
    
    @objc
    private func onChoseIrregularEventTracker() {
        guard let navigationController = navigationController else { return }
        router?.createNewTrackSecondStep(trackerType: TrackerType.irregularEvent, parentNavigationController: navigationController)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        view.addSubview(habitTrackerTypeButton)
        view.addSubview(irregularEventTrackerTypeButton)

        NSLayoutConstraint.activate([
            habitTrackerTypeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitTrackerTypeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitTrackerTypeButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventTrackerTypeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            irregularEventTrackerTypeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            irregularEventTrackerTypeButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventTrackerTypeButton.topAnchor.constraint(equalTo: habitTrackerTypeButton.bottomAnchor, constant: 16),
            irregularEventTrackerTypeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -268)
        ])
    }
}
