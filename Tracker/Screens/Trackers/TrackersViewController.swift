//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//

import UIKit

protocol TrackersViewProtocol: AnyObject{
    func showEmptyPlaceholder()
    
    func showEmptySearchPlaceholder()
    
    func showCurrentTrackers(categories: [TrackerCategory], completedTrackers: Set<TrackerRecord>)
    
    func bindTrackerViewCell(cell: TrackerViewCell, trackerView: TrackerView)
    
    func onTrackerCellButtonClick(trackerCell: TrackerViewCell)
}

final class TrackersViewController : UIViewController , TrackersViewProtocol {
    
    var router: ApplicationFlowRouter? = nil
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var searchText: String = ""
    private var presenter: TrackersPresenter? = nil
    private var addTrackerObserver: NSObjectProtocol?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.identifier)
        collectionView.register(CategoryTrackerViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryTrackerViewCell.identifier)
        collectionView.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(
            image: UIImage(named: "AddButton"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(onAddButtonClick)
        )
        addButton.tintColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        
        return addButton
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = dateFormatter.locale
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.compact
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.addTarget(self, action: #selector(onDateSelected(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var datePickerToolbarItem: UIBarButtonItem = {
        let datePickerToolbarItem = UIBarButtonItem(customView: datePicker)
        
        return datePickerToolbarItem
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField
            .addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        return searchController
    }()
    
    private lazy var emptyTrackersPlaceholderView: UIView = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12)
        placeHolderLabel.textAlignment = NSTextAlignment.center
        placeHolderLabel.text = "Что будем отслеживать?"
        let placeHolderImage = UIImageView(image: UIImage(named: "EmptyTrackersIll"))
        
        let stack = UIStackView()
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8
        stack.alignment = UIStackView.Alignment.center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        stack.addArrangedSubview(placeHolderImage)
        stack.addArrangedSubview(placeHolderLabel)
        
        return stack
    }()
    
    private lazy var emptySearchTrackersPlaceholderView: UIView = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12)
        placeHolderLabel.textAlignment = NSTextAlignment.center
        placeHolderLabel.text = "Ничего не найдено"
        let placeHolderImage = UIImageView(image: UIImage(named: "EmptySearchTrackersIll"))
        
        let stack = UIStackView()
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8
        stack.alignment = UIStackView.Alignment.center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(placeHolderImage)
        stack.addArrangedSubview(placeHolderLabel)
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        configureUI()
        configureNavigationBar()
        configureObserver()
        
        presenter = TrackersPresenter(trackersView: self)
        applyConditionAndShowTrackers()
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        searchText = text
        applyConditionAndShowTrackers()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func onAddButtonClick() {
        router?.createNewTrackFirstStep(parentVC: self)
    }
    
    @objc private func onDateSelected(_ sender: UIDatePicker) {
        presenter?.updateCurrentDate(date: sender.date)
        applyConditionAndShowTrackers()
    }
    
    func showEmptyPlaceholder() {
        collectionView.isHidden = true
        emptySearchTrackersPlaceholderView.isHidden = true
        emptyTrackersPlaceholderView.isHidden = false
    }
    
    func showEmptySearchPlaceholder() {
        collectionView.isHidden = true
        emptySearchTrackersPlaceholderView.isHidden = false
        emptyTrackersPlaceholderView.isHidden = true
    }
    
    func showCurrentTrackers(categories: [TrackerCategory], completedTrackers: Set<TrackerRecord>) {
        collectionView.isHidden = false
        emptySearchTrackersPlaceholderView.isHidden = true
        emptyTrackersPlaceholderView.isHidden = true
        
        self.visibleCategories = categories
        self.completedTrackers = completedTrackers
        collectionView.reloadData()
    }
    
    func bindTrackerViewCell(cell: TrackerViewCell, trackerView: TrackerView) {
        cell.bindCell(tracker: trackerView)
        cell.delegate = self
    }
    
    func onTrackerCellButtonClick(trackerCell: TrackerViewCell) {
        guard let id = trackerCell.trackerId else { return }
        presenter?.completeTracker(trackerId: id)
        applyConditionAndShowTrackers()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        
        view.addSubview(collectionView)
        view.addSubview(emptyTrackersPlaceholderView)
        view.addSubview(emptySearchTrackersPlaceholderView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            emptySearchTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptySearchTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureObserver() {
        addTrackerObserver = NotificationCenter
            .default
            .addObserver(
                forName: TrackersRepository.changeContentNotification,
                object: nil,
                queue: OperationQueue.main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.applyConditionAndShowTrackers()
            }
    }
    
    private func configureNavigationBar() {
        navigationItem.standardAppearance?.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.dsColor(dsColor: DSColor.dayBlack),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)
        ]
        title = "Трекеры"
        
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = datePickerToolbarItem
        navigationItem.searchController = searchController
    }
    
    private func applyConditionAndShowTrackers() {
        if searchText.isEmpty {
            presenter?.showCurrentTrackers()
            return
        }
        presenter?.searchTrackersByName(name: searchText)
    }
}


extension TrackersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
        let newLength = text.count + string.count - range.length
        return newLength <= 38
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width - 41) / 2.0, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 16, bottom: 32, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories.indices.contains(section) ? visibleCategories[section].trackers.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.identifier, for: indexPath) as? TrackerViewCell else { return UICollectionViewCell() }
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        presenter?.onBindTrackerCell(cell: cell, tracker: currentTracker)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let trackerCategoryCell = collectionView
            .dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: CategoryTrackerViewCell.identifier,
                for: indexPath
            ) as? CategoryTrackerViewCell else { return .init() }

        trackerCategoryCell.bindCell(categoryName: visibleCategories[indexPath.section].name)
        return trackerCategoryCell
    }
}
