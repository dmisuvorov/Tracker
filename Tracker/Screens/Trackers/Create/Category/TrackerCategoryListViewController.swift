//
//  TrackerCategoryListViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 14.05.2023.
//

import UIKit

final class TrackerCategoryListViewController: UIViewController {
    weak var trackerCategoryDelegate: TrackerCategoryDelegate? = nil
    var router: ApplicationFlowRouter? = nil
    
    private let viewModel: TrackerCategoryViewModel
    
    private lazy var emptyCategoriesPlaceholderView: UIView = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12)
        placeHolderLabel.textAlignment = NSTextAlignment.center
        placeHolderLabel.numberOfLines = 2
        placeHolderLabel.text = "Привычки и события можно\nобъединить по смыслу"
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
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.backgroundColor = UIColor.dsColor(dsColor: DSColor.black)
        addButton.setTitle("Добавить категорию", for: UIControl.State.normal)
        addButton.setTitleColor(UIColor.dsColor(dsColor: DSColor.white), for: UIControl.State.normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(onCreateCategoryButtonClick), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()
    
    private lazy var categoryList: UITableView = {
        let categoryList = UITableView()
        categoryList.register(TrackerCategoryViewCell.self, forCellReuseIdentifier: TrackerCategoryViewCell.identifier)
        categoryList.separatorColor = UIColor.dsColor(dsColor: DSColor.gray)
        categoryList.layer.masksToBounds = true
        categoryList.delegate = self
        categoryList.dataSource = self
        categoryList.translatesAutoresizingMaskIntoConstraints = false
        return categoryList
    }()
    
    init(viewModel: TrackerCategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    @objc
    private func onCreateCategoryButtonClick() {
        guard let navigationController = self.navigationController else { return }
        
        router?.createNewTrackerCategory(trackerCategoryViewModel: viewModel, parentNavigationController: navigationController)
    }
    
    private func bindViewModel() {
        viewModel.$categories.bind { [weak self] trackerCategories in
            self?.categoryList.reloadData()
        }
        
        viewModel.$isPlaceholderViewHidden.bind { [weak self] isHidden in
            self?.emptyCategoriesPlaceholderView.isHidden = isHidden
        }
        
        viewModel.$selectedCategory.bind { [weak self] selectedCategory in
            guard let selectedCategory = selectedCategory else { return }
            
            self?.trackerCategoryDelegate?.onSelectCategory(selectedCategory: selectedCategory.name)
            self?.navigationController?.popViewController(animated: true)
        }
        
        viewModel.onBindCategoryList()
    }
    
    private func configureUI() {
        title = "Категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.white)
        view.addSubview(categoryList)
        view.addSubview(addButton)
        view.addSubview(emptyCategoriesPlaceholderView)
        
        NSLayoutConstraint.activate([
            categoryList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryList.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -47),
            categoryList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            categoryList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emptyCategoriesPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyCategoriesPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        categoryList.tableHeaderView = UIView.init()
    }
}

extension TrackerCategoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoryList.dequeueReusableCell(withIdentifier: TrackerCategoryViewCell.identifier, for: indexPath) as? TrackerCategoryViewCell else { return .init() }
        let category = viewModel.categories[indexPath.row]
        let isLastRow = indexPath.row == viewModel.categories.count - 1
        let cornerMask: CACornerMask
        
        if viewModel.categories.count == 1 {
            cornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            switch (indexPath.row) {
            case 0: cornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case viewModel.categories.count - 1: cornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            default: cornerMask = []
            }
        }
        
        cell.bindCell(
            name: category.name,
            isSelected: category == viewModel.selectedCategory,
            corners: cornerMask,
            isShowDivider: !isLastRow
        )
        return cell
    }
}

extension TrackerCategoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TrackerCategoryViewCell else { return }
        cell.setSelected(isSelected: true)
        let category = viewModel.categories[indexPath.row]
        viewModel.onSelectNewCategory(category: category)
    }
}
