//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 08.04.2023.
//
import UIKit

final class TrackerDetailsViewController : UIViewController {
    var trackerDetailsModel: TrackerDetailsView? {
        didSet {
            guard isViewLoaded else { return }
            setTitle(trackerDetailsModel)
            configureTrackerConfig()
        }
    }
    
    var router: ApplicationFlowRouter? = nil
    
    private var currentTrackerName: String? { didSet { updateCreateButtonStatus() } }
    private var selectedCategory: String? = nil { didSet { updateCreateButtonStatus() } }
    private var selectedSchedule: Set<Day> = [] { didSet { updateCreateButtonStatus() } }
    private var selectedEmoji: String = "" { didSet { updateCreateButtonStatus() } }
    private var selectedColor: String? = nil { didSet { updateCreateButtonStatus() } }
    private var currentCountCompleted: Int = 0
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
    
    private lazy var counterHStack: UIStackView = {
        let counterHStack = UIStackView()
        counterHStack.axis = NSLayoutConstraint.Axis.horizontal
        counterHStack.distribution = UIStackView.Distribution.fill
        counterHStack.spacing = 24
        counterHStack.translatesAutoresizingMaskIntoConstraints = false
        return counterHStack
    }()
    
    private lazy var decreaseButton: UIButton = {
        let decreaseButton = UIButton()
        decreaseButton.setImage(UIImage(systemName: "minus"), for: .normal)
        decreaseButton.tintColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        decreaseButton.layer.masksToBounds = true
        decreaseButton.layer.cornerRadius = 17
        decreaseButton.translatesAutoresizingMaskIntoConstraints = false
        decreaseButton.addTarget(self, action: #selector(onDecreaseButtonClick), for: UIControl.Event.touchUpInside)
        return decreaseButton
    }()
    
    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        counterLabel.text = "0 дней"
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        return counterLabel
    }()
    
    private lazy var increaseButton: UIButton = {
        let increaseButton = UIButton()
        increaseButton.setImage(UIImage(systemName: "plus"), for: .normal)
        increaseButton.tintColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        increaseButton.layer.masksToBounds = true
        increaseButton.layer.cornerRadius = 17
        increaseButton.translatesAutoresizingMaskIntoConstraints = false
        increaseButton.addTarget(self, action: #selector(onIncreaseButtonClick), for: UIControl.Event.touchUpInside)
        return increaseButton
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
                    selectedCategoryName: self.selectedCategory,
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
    
    private lazy var storeButton: UIButton = {
        let createButton = UIButton()
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
        createButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.dayWhite), for: UIControl.State.normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.setTitle("Создать", for: UIControl.State.normal)
        createButton.translatesAutoresizingMaskIntoConstraints = true
        createButton.isEnabled = false
        createButton.addTarget(self, action: #selector(onStoreButtonClick), for: UIControl.Event.touchUpInside)
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
    private func onDecreaseButtonClick() {
        if currentCountCompleted > 0 {
            currentCountCompleted -= 1
            counterLabel.text = "\(currentCountCompleted) \(currentCountCompleted.daysString())"
        }
    }
    
    @objc
    private func onIncreaseButtonClick() {
        currentCountCompleted += 1
        counterLabel.text = "\(currentCountCompleted) \(currentCountCompleted.daysString())"
    }
    
    @objc
    private func onStoreButtonClick() {
        guard let currentTrackerName = currentTrackerName,
              let selectedColor = selectedColor,
              let selectedCategory = selectedCategory,
              !selectedEmoji.isEmpty else { return }
        
        if trackerDetailsModel?.flow == TrackerDetailsFlow.create {
            createNewTracker(
                name: currentTrackerName,
                color: selectedColor,
                categoryName: selectedCategory
            )
        } else if let initialTracker = trackerDetailsModel?.trackerInfo.trackerDetails {
            updateCurrentTracker(
                initialTracker: initialTracker,
                name: currentTrackerName,
                color: selectedColor,
                categoryName: selectedCategory
            )
        }
        dismiss(animated: true)
    }
    
    private func createNewTracker(name: String, color: String, categoryName: String) {
        let newTracker = Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: selectedEmoji,
            isPinned: false,
            day: trackerDetailsModel?.trackerInfo.type == TrackerType.irregularEvent ? nil : selectedSchedule
        )
        trackersRepository.addNewTracker(tracker: newTracker, categoryName: categoryName)
    }
    
    private func updateCurrentTracker(initialTracker: Tracker, name: String, color: String, categoryName: String) {
        let newTracker = Tracker(
            id: initialTracker.id,
            name: name,
            color: color,
            emoji: selectedEmoji,
            isPinned: initialTracker.isPinned,
            day: trackerDetailsModel?.trackerInfo.type == TrackerType.irregularEvent ? nil : selectedSchedule
        )
        trackersRepository.updateCurrentTracker(tracker: newTracker, categoryName: categoryName)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        navigationItem.hidesBackButton = true
        setTitle(trackerDetailsModel)
        configureScroll()
        if trackerDetailsModel?.flow == TrackerDetailsFlow.edit {
            configureCounter()
        }
        configureTrackerNameTextField()
        configureTrackerConfig()
        configureEmoji()
        configureColor()
        configureButtons()
    }
    
    private func setTitle(_ trackerDetailsModel: TrackerDetailsView?) {
        guard let trackerDetailsModel = trackerDetailsModel else { return }
        if trackerDetailsModel.flow == TrackerDetailsFlow.edit {
            title = "Редактирование привычки"
            return
        }
        title = trackerDetailsModel.trackerInfo.type == TrackerType.habit ? "Новая привычка" : "Новое нерегулярное событие"
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
    
    private func configureCounter() {
        counterHStack.addArrangedSubview(decreaseButton)
        counterHStack.addArrangedSubview(counterLabel)
        counterHStack.addArrangedSubview(increaseButton)
        scrollContainerView.addSubview(counterHStack)
        NSLayoutConstraint.activate([
            decreaseButton.heightAnchor.constraint(equalToConstant: 34),
            decreaseButton.widthAnchor.constraint(equalToConstant: 34),
            increaseButton.heightAnchor.constraint(equalToConstant: 34),
            increaseButton.widthAnchor.constraint(equalToConstant: 34),
            counterLabel.topAnchor.constraint(equalTo: scrollContainerView.topAnchor, constant: 38),
            
            counterHStack.centerXAnchor.constraint(equalTo: scrollContainerView.centerXAnchor),
        ])
    }
    
    private func configureTrackerNameTextField() {
        scrollContainerView.addSubview(trackerNameBackgroundShape)
        trackerNameBackgroundShape.addSubview(trackerNameTextField)
        let topAnchorConstraintTo: NSLayoutYAxisAnchor
        let topAnchorConstantInset: CGFloat
        if trackerDetailsModel?.flow == TrackerDetailsFlow.create {
            topAnchorConstraintTo = scrollContainerView.topAnchor
            topAnchorConstantInset = 0
        } else {
            topAnchorConstraintTo = counterHStack.bottomAnchor
            topAnchorConstantInset = 40
        }
        NSLayoutConstraint.activate([
            trackerNameBackgroundShape.topAnchor.constraint(equalTo: topAnchorConstraintTo, constant: topAnchorConstantInset),
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
        configureTrackerDetails(trackerInfo: trackerDetailsModel?.trackerInfo)
        if trackerDetailsModel?.flow == TrackerDetailsFlow.edit {
            configureEditFlow()
        }
        if trackerDetailsModel?.trackerInfo.type == TrackerType.habit {
            configureHabitTracker()
            return
        }
        configureIrregularEventTracker()
    }
    
    private func configureEditFlow() {
        storeButton.setTitle("Сохранить", for: UIControl.State.normal)
        guard let trackerInfo = trackerDetailsModel?.trackerInfo,
              let trackerDetails = trackerInfo.trackerDetails,
              let countCompleted = trackerInfo.countCompleted else { return }
        currentCountCompleted = countCompleted
        decreaseButton.backgroundColor = UIColor(named: trackerDetails.color)
        increaseButton.backgroundColor = UIColor(named: trackerDetails.color)
        counterLabel.text = "\(countCompleted) \(countCompleted.daysString())"
    }
    
    private func configureTrackerDetails(trackerInfo: TrackerDetailsInfo?) {
        guard let trackerInfo = trackerInfo,
              let currentCategoryName = trackerInfo.categoryName,
              let trackerDetails = trackerInfo.trackerDetails else { return }
        trackerNameTextField.text = trackerDetails.name
        currentTrackerName = trackerDetails.name
        
        categoryTrackerCell.updateSubtitle(subtitle: currentCategoryName)
        selectedCategory = currentCategoryName
        if let schedule = trackerDetails.day {
            scheduleTrackerCell.updateSubtitle(subtitle: schedule.toShortDescription())
            selectedSchedule = schedule
        }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let emojiIndex = IndexPath(row: self.emojiRepository.findEmojiIndex(emoji: trackerDetails.emoji) ?? 0, section: 0)
            self.emojiCollectionView.selectItem(at: emojiIndex, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            self.collectionView(self.emojiCollectionView, didSelectItemAt: emojiIndex)
            let colorIndex = IndexPath(row: self.colorRepository.findColorIndex(color: trackerDetails.color) ?? 0, section: 0)
            self.colorCollectionView.selectItem(at: colorIndex, animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            self.collectionView(self.colorCollectionView, didSelectItemAt: colorIndex)
        }
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
        if trackerDetailsModel?.trackerInfo.type == TrackerType.habit {
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
        trackerButtonsHStack.addArrangedSubview(storeButton)
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            storeButton.heightAnchor.constraint(equalToConstant: 60),
            trackerButtonsHStack.topAnchor.constraint(equalTo: colorCollectionView.bottomAnchor, constant: 30),
            trackerButtonsHStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            trackerButtonsHStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            trackerButtonsHStack.bottomAnchor.constraint(equalTo: scrollContainerView.bottomAnchor)
        ])
    }
    
    private func updateCreateButtonStatus() {
        let isValidTrackerName = currentTrackerName?.isEmpty == false
        let isValidTrackerCategory = selectedCategory != nil
        let isValidSchedule = trackerDetailsModel?.trackerInfo.type == TrackerType.irregularEvent || selectedSchedule.isEmpty == false
        let isValidEmoji = selectedEmoji.isEmpty == false
        let isValidColor = selectedColor != nil
        
        let isEnabledCreateButton = isValidTrackerName && isValidTrackerCategory && isValidSchedule && isValidEmoji && isValidColor
        if isEnabledCreateButton {
            storeButton.isEnabled = true
            storeButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
            return
        }
        storeButton.isEnabled = false
        storeButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
    }
}

extension TrackerDetailsViewController : ScheduleDelegate {
    func onSelectSchedule(selectedDays: Set<Day>) {
        selectedSchedule = selectedDays
        scheduleTrackerCell.updateSubtitle(subtitle: selectedSchedule.toShortDescription())
    }
}

extension TrackerDetailsViewController : TrackerCategoryDelegate {
    func onSelectCategory(selectedCategory: String) {
        self.selectedCategory = selectedCategory
        categoryTrackerCell.updateSubtitle(subtitle: selectedCategory)
    }
}

extension TrackerDetailsViewController: UICollectionViewDataSource {
    
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

extension TrackerDetailsViewController: UICollectionViewDelegateFlowLayout {
    
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

extension TrackerDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == emojiCollectionTag {
            guard let emojiCell = collectionView.cellForItem(at: indexPath) as? EmojiViewCell else { return }
            emojiCell.selectCell()
            selectedEmoji = emojiCell.currentEmoji
            return
        }
        guard let colorCell = collectionView.cellForItem(at: indexPath) as? ColorViewCell else { return }
        colorCell.selectCell()
        selectedColor = colorCell.currentColorString
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
