//
//  CreateTrackerCategoryViewModel.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 19.05.2023.
//

import UIKit

final class CreateTrackerCategoryViewController: UIViewController {
    private let viewModel: TrackerCategoryViewModel
    
    private lazy var trackerCategoryBackgroundShape: UIView = {
        let trackerCategoryBackgroundShape = UIView()
        trackerCategoryBackgroundShape.layer.masksToBounds = true
        trackerCategoryBackgroundShape.layer.cornerRadius = 16
        trackerCategoryBackgroundShape.clipsToBounds = true
        trackerCategoryBackgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.background)
        trackerCategoryBackgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return trackerCategoryBackgroundShape
    }()
    
    private lazy var trackerCategoryTextField: UITextField = {
        let trackerCategoryTextField = UITextField()
        trackerCategoryTextField.font = UIFont.systemFont(ofSize: 17)
        trackerCategoryTextField.addTarget(self, action: #selector(onTrackerCategoryChanged), for: UIControl.Event.allEditingEvents)
        trackerCategoryTextField.placeholder = "enter_category_name".localized
        trackerCategoryTextField.translatesAutoresizingMaskIntoConstraints = false
        return trackerCategoryTextField
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
        createButton.setTitle("done".localized, for: UIControl.State.normal)
        createButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.white), for: UIControl.State.normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.layer.cornerRadius = 16
        createButton.addTarget(self, action: #selector(onCreateButtonClick), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        return createButton
    }()
    
    init(viewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    @objc
    private func onTrackerCategoryChanged(_ sender: UITextInput) {
        viewModel.onChangeNewTrackerCategoryName(currentNewCategoryName: trackerCategoryTextField.text)
    }
    
    @objc
    private func onCreateButtonClick() {
        viewModel.onCreateNewCategoryButtonClick()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$currentNewCategoryName.bind { [weak self] trackerCategoryName in
            guard let self = self else { return }
            let isEnabledCreateButton = !trackerCategoryName.isEmpty
            if isEnabledCreateButton {
                self.createButton.isEnabled = true
                self.createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.black)
                return
            }
            self.createButton.isEnabled = false
            self.createButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
        }
    }
    
    private func configureUI() {
        title = "new_category".localized
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.white)
        view.addSubview(trackerCategoryBackgroundShape)
        view.addSubview(createButton)
        trackerCategoryBackgroundShape.addSubview(trackerCategoryTextField)
        
        NSLayoutConstraint.activate([
            trackerCategoryBackgroundShape.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCategoryBackgroundShape.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackerCategoryBackgroundShape.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackerCategoryBackgroundShape.heightAnchor.constraint(equalToConstant: 75),

            trackerCategoryTextField.centerYAnchor.constraint(equalTo: trackerCategoryBackgroundShape.centerYAnchor),
            trackerCategoryTextField.centerXAnchor.constraint(equalTo: trackerCategoryBackgroundShape.centerXAnchor),
            trackerCategoryTextField.leadingAnchor.constraint(equalTo: trackerCategoryBackgroundShape.leadingAnchor, constant: 16),
            trackerCategoryTextField.trailingAnchor.constraint(equalTo: trackerCategoryBackgroundShape.trailingAnchor, constant: -29),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
}
