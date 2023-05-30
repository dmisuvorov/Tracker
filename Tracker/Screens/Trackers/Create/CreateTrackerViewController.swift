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
    var router: ApplicationFlowRouter? = nil
    
    private var currentTrackerName: String? { didSet { updateCreateButtonStatus() } }
    private var selectedCategory: TrackerCategory? = nil { didSet { updateCreateButtonStatus() } }
    private var selectedSchedule: Set<Day> = [] { didSet { updateCreateButtonStatus() } }
    private var selectedEmoji: String = "" { didSet { updateCreateButtonStatus() } }
    private var selectedColor: UIColor? = nil { didSet { updateCreateButtonStatus() } }
    private let trackersRepository: TrackersRepository = TrackersRepository.shared
    private let emojiRepository: EmojiRepository = EmojiRepository.shared
    private let colorRepository: ColorSelectionRepository = ColorSelectionRepository.shared
    
    private let emojiCollectionTag = 100
    private let colorsCollectionTag = 101
    
    private lazy var scrollContainerView: UIScrollView = {
        let scrollContainerView = UIScrollView()
        scrollContainerView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 820)
        scrollContainerView.isPagingEnabled = false
        scrollContainerView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        scrollContainerView.showsVerticalScrollIndicator = false
        scrollContainerView.showsHorizontalScrollIndicator = false
        scrollContainerView.translatesAutoresizingMaskIntoConstraints = false
        return scrollContainerView
    }()
    
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
        let categoryTrackerCell = TrackerConfigCell(title: "Категория", onClick: { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            
            self.router?
                .confugureNewTrackerCategory(
                    selectedCategory: self.selectedCategory,
                    trackerCategoryDelegate: self,
                    parentNavigationController: navigationController
                )
        })
        categoryTrackerCell.translatesAutoresizingMaskIntoConstraints = false
        return categoryTrackerCell
    }()
    
    private lazy var scheduleTrackerCell: TrackerConfigCell = {
        let scheduleTrackerCell = TrackerConfigCell(title: "Расписание", onClick: { [weak self] in
            guard let self = self, let navigationController = self.navigationController else { return }
            
            self.router?
                .confugureNewTrackerSchedule(
                    selectedSchedule: self.selectedSchedule,
                    scheduleDelegate: self,
                    parentNavigationController: navigationController
                )
        })
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
    
    private lazy var emojiTitleLabel: UILabel = {
        let emojiTitleLabel = UILabel()
        emojiTitleLabel.text = "Emoji"
        emojiTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold)
        emojiTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiTitleLabel
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let emojiCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        emojiCollectionView.register(EmojiViewCell.self, forCellWithReuseIdentifier: EmojiViewCell.identifier)
        emojiCollectionView.tag = emojiCollectionTag
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    }()
    
    private lazy var colorTitleLabel: UILabel = {
        let colorTitleLabel = UILabel()
        colorTitleLabel.text = "Цвет"
        colorTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold)
        colorTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return colorTitleLabel
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let colorCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        colorCollectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: ColorViewCell.identifier)
        colorCollectionView.tag = colorsCollectionTag
        colorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        return colorCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureUI()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func onTrackerNameChanged(_ sender: UITextInput) {
        currentTrackerName = trackerNameTextField.text
    }
    
    @objc
    private func onCancelButtonClick() {
        dismiss(animated: true)
    }
    
    @objc
    private func onCreateButtonClick() {
        guard let currentTrackerName = currentTrackerName,
              let selectedColor = selectedColor,
              let selectedCategory = selectedCategory,
              !selectedEmoji.isEmpty else { return }
        
        let newTracker = Tracker(
            id: UUID(),
            name: currentTrackerName,
            color: selectedColor.colorToHexString(),
            emoji: selectedEmoji,
            isPinned: false,
            day: trackerType == TrackerType.irregularEvent ? nil : selectedSchedule
        )
        trackersRepository.addNewTracker(tracker: newTracker, categoryName: selectedCategory.name)
        dismiss(animated: true)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        navigationItem.hidesBackButton = true
        setTitle(trackerType)
        configureScroll()
        configureTrackerNameTextField()
        configureTrackerConfig()
        configureEmoji()
        configureColor()
        configureButtons()
    }
    
    private func setTitle(_ trackerType: TrackerType?) {
        guard let trackerType = trackerType else { return }
        title = trackerType == TrackerType.habit ? "Новая привычка" : "Новое нерегулярное событие"
    }
    
    private func configureScroll() {
        view.addSubview(scrollContainerView)
        
        NSLayoutConstraint.activate([
            scrollContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureTrackerNameTextField() {
        scrollContainerView.addSubview(trackerNameBackgroundShape)
        trackerNameBackgroundShape.addSubview(trackerNameTextField)
        NSLayoutConstraint.activate([
            trackerNameBackgroundShape.topAnchor.constraint(equalTo: scrollContainerView.topAnchor),
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
        scrollContainerView.addSubview(categoryTrackerCell)
        scrollContainerView.addSubview(scheduleTrackerCell)
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
        scrollContainerView.addSubview(categoryTrackerCell)
        NSLayoutConstraint.activate([
            categoryTrackerCell.topAnchor.constraint(equalTo: trackerNameBackgroundShape.bottomAnchor, constant: 24),
            categoryTrackerCell.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTrackerCell.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTrackerCell.heightAnchor.constraint(equalToConstant: 75),
        ])
    }
    
    private func configureEmoji() {
        scrollContainerView.addSubview(emojiTitleLabel)
        scrollContainerView.addSubview(emojiCollectionView)
        let topAnchorConstraintTo: NSLayoutYAxisAnchor
        if trackerType == TrackerType.habit {
            topAnchorConstraintTo = scheduleTrackerCell.bottomAnchor
        } else {
            topAnchorConstraintTo = categoryTrackerCell.bottomAnchor
        }
        NSLayoutConstraint.activate([
            emojiTitleLabel.leadingAnchor.constraint(equalTo: scrollContainerView.leadingAnchor, constant: 28),
            emojiTitleLabel.topAnchor.constraint(equalTo: topAnchorConstraintTo, constant: 32),
            
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emojiCollectionView.topAnchor.constraint(equalTo: emojiTitleLabel.bottomAnchor, constant: 24),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 156)
        ])
    }
    
    private func configureColor() {
        scrollContainerView.addSubview(colorTitleLabel)
        scrollContainerView.addSubview(colorCollectionView)
        NSLayoutConstraint.activate([
            colorTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            colorTitleLabel.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 32),
            
            colorCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            colorCollectionView.topAnchor.constraint(equalTo: colorTitleLabel.bottomAnchor, constant: 24),
            colorCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -29),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 156)
        ])
    }
    
    private func configureButtons() {
        scrollContainerView.addSubview(trackerButtonsHStack)
        trackerButtonsHStack.addArrangedSubview(cancelButton)
        trackerButtonsHStack.addArrangedSubview(createButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            trackerButtonsHStack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 30),
            trackerButtonsHStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trackerButtonsHStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            trackerButtonsHStack.bottomAnchor.constraint(equalTo: scrollContainerView.bottomAnchor)
        ])
    }
    
    private func updateCreateButtonStatus() {
        let isValidTrackerName = currentTrackerName?.isEmpty == false
        let isValidTrackerCategory = selectedCategory != nil
        let isValidSchedule = trackerType == TrackerType.irregularEvent || selectedSchedule.isEmpty == false
        let isValidEmoji = selectedEmoji.isEmpty == false
        let isValidColor = selectedColor != nil
        
        let isEnabledCreateButton = isValidTrackerName && isValidTrackerCategory && isValidSchedule && isValidEmoji && isValidColor
        if isEnabledCreateButton {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
            return
        }
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
    }
}

extension CreateTrackerViewController : ScheduleDelegate {
    func onSelectSchedule(selectedDays: Set<Day>) {
        selectedSchedule = selectedDays
        scheduleTrackerCell.updateSubtitle(subtitle: selectedSchedule.toShortDescription())
    }
}

extension CreateTrackerViewController : TrackerCategoryDelegate {
    func onSelectCategory(selectedCategory: TrackerCategory) {
        self.selectedCategory = selectedCategory
        categoryTrackerCell.updateSubtitle(subtitle: selectedCategory.name)
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == emojiCollectionTag {
            return emojiRepository.currentEmojies.count
        }
        return colorRepository.currentColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == emojiCollectionTag {
            return configureEmojiCell(collectionView, cellForItemAt: indexPath)
        }
        return configureColorCell(collectionView, cellForItemAt: indexPath)
    }
    
    
    private func configureEmojiCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiViewCell.identifier, for: indexPath) as? EmojiViewCell else { return UICollectionViewCell() }
        
        let currentEmoji = emojiRepository.currentEmojies[indexPath.row]
        cell.bindCell(emoji: currentEmoji)
        return cell
    }
    
    private func configureColorCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.identifier, for: indexPath) as? ColorViewCell else { return UICollectionViewCell() }
        
        let currentColor = colorRepository.currentColors[indexPath.row]
        cell.bindCell(color: currentColor)
        return cell
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return UIScreen.main.bounds.width / 75
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == emojiCollectionTag {
            guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiViewCell else { return }
            emojiCell.selectCell()
            selectedEmoji = emojiCell.currentEmoji
            return
        }
        guard let colorCell = collectionView.cellForItem(at: indexPath) as? ColorViewCell else { return }
        colorCell.selectCell()
        selectedColor = colorCell.currentColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == emojiCollectionTag {
            guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiViewCell else { return }
            emojiCell.unselectCell()
            return
        }
        guard let colorCell = collectionView.cellForItem(at: indexPath) as? ColorViewCell else { return }
        colorCell.unselectCell()
    }
}
