//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//

import UIKit

final class TrackersViewController : UIViewController {
    var router: ApplicationFlowRouter? = nil
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var currentDate: Date = Date()
    
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
        
        return datePicker
    }()
    
    private lazy var datePickerToolbarItem: UIBarButtonItem = {
        let datePickerToolbarItem = UIBarButtonItem(customView: datePicker)
        
        return datePickerToolbarItem
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchTextField.delegate = self
        
        return searchController
    }()
    
    private lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    
    private lazy var emptyTrackersPlaceholderView: UIView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
    }
    
    @objc private func onAddButtonClick() {
        router?.createNewTrackFirstStep(parentVC: self)
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        
        view.addSubview(collectionView)
        view.addSubview(emptyTrackersPlaceholderView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            emptyTrackersPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyTrackersPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
}


extension TrackersViewController: UITextFieldDelegate {
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories.indices.contains(section) ? visibleCategories[section].trackers.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.identifier, for: indexPath) as? TrackerViewCell else { return UICollectionViewCell() }
        
        let currentTracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCurrentTrackerDoneInCurrentDate = completedTrackers.filter { $0.id == currentTracker.id && $0.date == currentDate }.count > 0
        let countOfCompleted = completedTrackers.filter { $0.id == currentTracker.id }.count
        let trackerView = TrackerView(
            name: currentTracker.name,
            color: currentTracker.color,
            emoji: currentTracker.emoji,
            daysCompleted: "\(countOfCompleted) \(countOfCompleted.daysString())",
            isDoneInCurrentDate: isCurrentTrackerDoneInCurrentDate
        )
        cell.bindCell(tracker: trackerView)
        return cell
    }
}
