//
//  TrackerCategoryViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 14.05.2023.
//

import UIKit

final class TrackerCategoryViewCell: UITableViewCell {
    static let identifier = "TrackerCategoryViewCell"
    
    private lazy var backgroundShape: UIView = {
        let backgroundShape = UIView()
        backgroundShape.layer.masksToBounds = true
        backgroundShape.layer.cornerRadius = 16
        backgroundShape.clipsToBounds = true
        backgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBackground)
        backgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return backgroundShape
    }()
    
    private lazy var nameLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = UIFont.systemFont(ofSize: 17)
        dayLabel.textColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private lazy var checkmarkIv: UIImageView = {
        let checkmarkIv = UIImageView()
        checkmarkIv.image = UIImage(named: "CheckmarkIcon")
        checkmarkIv.tintColor = UIColor.dsColor(dsColor: DSColor.blue)
        checkmarkIv.isHidden = true
        checkmarkIv.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkIv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureUI()
    }
    
    func bindCell(name: String, isSelected: Bool, corners: CACornerMask) {
        nameLabel.text = name
        setSelected(isSelected: isSelected)
        backgroundShape.layer.maskedCorners = corners
    }
    
    func setSelected(isSelected: Bool) {
        checkmarkIv.isHidden = !isSelected
    }
    
    private func configureUI() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.addSubview(backgroundShape)
        backgroundShape.addSubview(nameLabel)
        backgroundShape.addSubview(checkmarkIv)
        NSLayoutConstraint.activate([
            backgroundShape.heightAnchor.constraint(equalToConstant: 75),
            backgroundShape.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundShape.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundShape.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundShape.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundShape.leadingAnchor, constant: 16),
            
            checkmarkIv.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor),
            checkmarkIv.trailingAnchor.constraint(equalTo: backgroundShape.trailingAnchor, constant: -20),
        ])
    }
}
