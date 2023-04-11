//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 08.04.2023.
//
import UIKit

final class CreateTrackerViewController : UIViewController {
    var trackerType: TrackerType? {
        didSet {
            guard isViewLoaded else { return }
            setTitle(trackerType)
            configureTrackerConfig()
        }
    }
    
    private var currentTrackerName: String? { didSet { updateCreateButtonStatus() } }
    
    private lazy var trackerNameBackgroundShape: UIView = {
        let trackerNameBackgroundShape = UIView()
        trackerNameBackgroundShape.layer.masksToBounds = true
        trackerNameBackgroundShape.layer.cornerRadius = 16
        trackerNameBackgroundShape.clipsToBounds = true
        trackerNameBackgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBackground)
        trackerNameBackgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameBackgroundShape
    }()
    
    private lazy var trackerNameTextField: UITextField = {
        let trackerNameTextField = UITextField()
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17)
        trackerNameTextField.addTarget(self, action: #selector(onTrackerNameChanged), for: UIControl.Event.allEditingEvents)
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameTextField
    }()
    
    private lazy var categoryTrackerCell: TrackerConfigCell = {
        let categoryTrackerCell = TrackerConfigCell(title: "Категория", subtitle: "По умолчанию")
        categoryTrackerCell.translatesAutoresizingMaskIntoConstraints = false
        return categoryTrackerCell
    }()
    
    private lazy var scheduleTrackerCell: TrackerConfigCell = {
        let scheduleTrackerCell = TrackerConfigCell(title: "Расписание")
        scheduleTrackerCell.translatesAutoresizingMaskIntoConstraints = false
        return scheduleTrackerCell
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.borderColor = UIColor.dsColor(dsColor: DSColor.red).cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.red), for: UIControl.State.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitle("Отменить", for: UIControl.State.normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = true
        cancelButton.addTarget(self, action: #selector(onCancelButtonClick), for: UIControl.Event.touchUpInside)
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
        createButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.dayWhite), for: UIControl.State.normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.setTitle("Создать", for: UIControl.State.normal)
        createButton.translatesAutoresizingMaskIntoConstraints = true
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(onCreateButtonClick), for: UIControl.Event.touchUpInside)
        return createButton
    }()
    
    private lazy var trackerButtonsHStack: UIStackView = {
        let trackerConfigVStack = UIStackView()
        trackerConfigVStack.layoutMargins = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        trackerConfigVStack.isLayoutMarginsRelativeArrangement = true
        trackerConfigVStack.axis = NSLayoutConstraint.Axis.horizontal
        trackerConfigVStack.distribution = UIStackView.Distribution.fillEqually
        trackerConfigVStack.spacing = 8
        trackerConfigVStack.translatesAutoresizingMaskIntoConstraints = false
        return trackerConfigVStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    @objc func onTrackerNameChanged(_ sender: UITextInput) {
        currentTrackerName = trackerNameTextField.text
    }
    
    @objc func onCancelButtonClick() {
        dismiss(animated: true)
    }
    
    @objc func onCreateButtonClick() {
        
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        navigationItem.hidesBackButton = true
        setTitle(trackerType)
        configureTrackerNameTextField()
        configureTrackerConfig()
        configureButtons()
    }
    
    private func setTitle(_ trackerType: TrackerType?) {
        guard let trackerType = trackerType else { return }
        title = trackerType == TrackerType.habit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    private func configureTrackerNameTextField() {
        view.addSubview(trackerNameBackgroundShape)
        trackerNameBackgroundShape.addSubview(trackerNameTextField)
        NSLayoutConstraint.activate([
            trackerNameBackgroundShape.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerNameBackgroundShape.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerNameBackgroundShape.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerNameBackgroundShape.heightAnchor.constraint(equalToConstant: 75),

            trackerNameTextField.centerYAnchor.constraint(equalTo: trackerNameBackgroundShape.centerYAnchor),
            trackerNameTextField.centerXAnchor.constraint(equalTo: trackerNameBackgroundShape.centerXAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: trackerNameBackgroundShape.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: trackerNameBackgroundShape.trailingAnchor, constant: -29)
        ])
    }
    
    private func configureTrackerConfig() {
        if trackerType == TrackerType.habit {
            configureHabitTracker()
            return
        }
        configureIrregularEventTracker()
    }
    
    private func configureHabitTracker() {
        categoryTrackerCell.showDivider()
        categoryTrackerCell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        scheduleTrackerCell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(categoryTrackerCell)
        view.addSubview(scheduleTrackerCell)
        NSLayoutConstraint.activate([
            categoryTrackerCell.topAnchor.constraint(equalTo: trackerNameBackgroundShape.bottomAnchor, constant: 24),
            categoryTrackerCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTrackerCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTrackerCell.heightAnchor.constraint(equalToConstant: 75),
            
            scheduleTrackerCell.topAnchor.constraint(equalTo: categoryTrackerCell.bottomAnchor),
            scheduleTrackerCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scheduleTrackerCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scheduleTrackerCell.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func configureIrregularEventTracker() {
        view.addSubview(categoryTrackerCell)
        NSLayoutConstraint.activate([
            categoryTrackerCell.topAnchor.constraint(equalTo: trackerNameBackgroundShape.bottomAnchor, constant: 24),
            categoryTrackerCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTrackerCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTrackerCell.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func configureButtons() {
        view.addSubview(trackerButtonsHStack)
        trackerButtonsHStack.addArrangedSubview(cancelButton)
        trackerButtonsHStack.addArrangedSubview(createButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            trackerButtonsHStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerButtonsHStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trackerButtonsHStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateCreateButtonStatus() {
        let isValidTrackerName = currentTrackerName != nil && currentTrackerName != ""
        
        let isEnabledCreateButton = isValidTrackerName
        if isEnabledCreateButton {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
            return
        }
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
    }
}
