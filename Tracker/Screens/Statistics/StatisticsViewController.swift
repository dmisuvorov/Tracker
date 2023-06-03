//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//

import UIKit

final class StatisticsViwController : UIViewController {
    private let viewModel = StatisticsViewModel()
    
    private lazy var emptyStatisticsPlaceholderView: UIView = {
        let placeHolderLabel = UILabel()
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12)
        placeHolderLabel.textAlignment = NSTextAlignment.center
        placeHolderLabel.text = "Анализировать пока нечего"
        let placeHolderImage = UIImageView(image: UIImage(named: "CrySmileIll"))
        
        let stack = UIStackView()
        stack.axis = NSLayoutConstraint.Axis.vertical
        stack.spacing = 8
        stack.alignment = UIStackView.Alignment.center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(placeHolderImage)
        stack.addArrangedSubview(placeHolderLabel)
        stack.isHidden = true
        return stack
    }()
    
    private lazy var itemStackView: UIStackView = {
        let itemStackView = UIStackView()
        itemStackView.axis = NSLayoutConstraint.Axis.vertical
        itemStackView.distribution = UIStackView.Distribution.fillEqually
        itemStackView.spacing = 12
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        return itemStackView
    }()
    
    private lazy var bestPeriodItemView: StatisticsItemView = {
        let bestPeriodItemView = StatisticsItemView(description: "Лучший период", counter: "-")
        bestPeriodItemView.translatesAutoresizingMaskIntoConstraints = false
        return bestPeriodItemView
    }()
    
    private lazy var bestDaysItemView: StatisticsItemView = {
        let bestDaysItemView = StatisticsItemView(description: "Идеальные дни", counter: "-")
        bestDaysItemView.translatesAutoresizingMaskIntoConstraints = false
        return bestDaysItemView
    }()
    
    private lazy var completedTrackersItemView: StatisticsItemView = {
        let completedTrackersItemView = StatisticsItemView(description: "Трекеров завершено", counter: "-")
        completedTrackersItemView.translatesAutoresizingMaskIntoConstraints = false
        return completedTrackersItemView
    }()
    
    private lazy var averageValueItemView: StatisticsItemView = {
        let averageValueItemView = StatisticsItemView(description: "Среднее значение", counter: "-")
        averageValueItemView.translatesAutoresizingMaskIntoConstraints = false
        return averageValueItemView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        initObservers()
        viewModel.onViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bestPeriodItemView.configureBorder()
        bestDaysItemView.configureBorder()
        completedTrackersItemView.configureBorder()
        averageValueItemView.configureBorder()
    }
    
    private func initObservers() {
        viewModel.$isPlaceholderViewHidden.bind { [weak self] isPlaceholderHidden in
            guard let self = self else { return }
            if isPlaceholderHidden {
                self.showCurrentStatistics()
                return
            }
            self.showEmptyStatisticsPlaceholder()
        }
        viewModel.$completedTrackersValue.bind { [weak self] value in
            guard let self = self else { return }
            self.completedTrackersItemView.update(newCounter: value)
        }
        viewModel.$bestPeriodValue.bind { [weak self] value in
            guard let self = self else { return }
            self.bestPeriodItemView.update(newCounter: value)
        }
        viewModel.$bestDaysValue.bind { [weak self] value in
            guard let self = self else { return }
            self.bestDaysItemView.update(newCounter: value)
        }
        viewModel.$averageValue.bind { [weak self] value in
            guard let self = self else { return }
            self.averageValueItemView.update(newCounter: value)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.white)
        configureNavigationBar()
        configurePlaceholder()
        configureItems()
    }
    
    private func configureNavigationBar() {
        navigationItem.standardAppearance?.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.dsColor(dsColor: DSColor.black),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34)
        ]
        title = "Статистика"
    }
    
    private func configurePlaceholder() {
        view.addSubview(emptyStatisticsPlaceholderView)
        NSLayoutConstraint.activate([
            emptyStatisticsPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticsPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func configureItems() {
        itemStackView.addArrangedSubview(bestPeriodItemView)
        itemStackView.addArrangedSubview(bestDaysItemView)
        itemStackView.addArrangedSubview(completedTrackersItemView)
        itemStackView.addArrangedSubview(averageValueItemView)
        view.addSubview(itemStackView)
        NSLayoutConstraint.activate([
            itemStackView.heightAnchor.constraint(equalToConstant: 396),
            itemStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            itemStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            itemStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func showEmptyStatisticsPlaceholder() {
        itemStackView.isHidden = true
        emptyStatisticsPlaceholderView.isHidden = false
    }
    
    private func showCurrentStatistics() {
        emptyStatisticsPlaceholderView.isHidden = true
        itemStackView.isHidden = false
    }
}
