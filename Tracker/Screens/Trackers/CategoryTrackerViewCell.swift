//
//  CategoryTrackerViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 14.04.2023.
//

import UIKit

final class CategoryTrackerViewCell: UICollectionReusableView {
    static let identifier = "CategoryTrackerViewCell"
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: UIFont.Weight.bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func bindCell(categoryName: String) {
        nameLabel.text = categoryName
    }
}
