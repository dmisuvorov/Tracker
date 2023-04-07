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
        router?.createNewTrack(parentVC: self)
    }
    
    private func configureUI() {
        emptyTrackersPlaceholderView.isHidden = false
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        
        view.addSubview(emptyTrackersPlaceholderView)
        
        NSLayoutConstraint.activate([
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
