//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.04.2023.
//

import UIKit

final class StatisticsViwController : UIViewController {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        showEmptyStatisticsPlaceholder()
    }
    
    
    private func configureUI() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.white)
        view.addSubview(emptyStatisticsPlaceholderView)
        NSLayoutConstraint.activate([
            emptyStatisticsPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStatisticsPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func showEmptyStatisticsPlaceholder() {
        emptyStatisticsPlaceholderView.isHidden = false
    }
}
