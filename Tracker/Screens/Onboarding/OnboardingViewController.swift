//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 14.05.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    var pageIndex: Int
    
    private let text: String
    private let image: UIImage
    
    private lazy var backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        return backgroundImage
    }()
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.numberOfLines = 2
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        textLabel.textColor = UIColor.dsColor(dsColor: DSColor.black)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    init(model: OnboardingModel, index: Int) {
        self.pageIndex = index
        self.text = model.text
        self.image = UIImage(named: model.image) ?? UIImage.checkmark
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override func viewDidLoad() {
        configureUI()
    }
    
    private func configureUI() {
        textLabel.text = text
        backgroundImage.image = image
        
        view.addSubview(backgroundImage)
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -304)
        ])
    }
}
