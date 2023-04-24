//
//  ScheduleViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 11.04.2023.
//

import UIKit

final class ScheduleViewCell : UITableViewCell {
    static let identifier = "ScheduleViewCell"
    
    private lazy var backgroundShape: UIView = {
        let backgroundShape = UIView()
        backgroundShape.layer.masksToBounds = true
        backgroundShape.layer.cornerRadius = 16
        backgroundShape.clipsToBounds = true
        backgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayBackground)
        backgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return backgroundShape
    }()
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = UIFont.systemFont(ofSize: 17)
        dayLabel.textColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private lazy var daySwitch: UISwitch = {
        let daySwitch = UISwitch()
        daySwitch.onTintColor = UIColor.dsColor(dsColor: DSColor.blue)
        daySwitch.isUserInteractionEnabled = false
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        return daySwitch
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
    
    func bindCell(day: String, isOn: Bool, corners: CACornerMask, isShowDivider: Bool = true) {
        dayLabel.text = day
        setSwitchPosition(isOn: isOn)
        backgroundShape.layer.maskedCorners = corners
        if !isShowDivider {
            separatorInset = UIEdgeInsets.init(top: 0, left: CGFloat.infinity, bottom: 0, right: 0)
        }
    }
    
    func setSwitchPosition(isOn: Bool) {
        daySwitch.setOn(isOn, animated: true)
    }
    
    private func configureUI() {
        selectionStyle = UITableViewCell.SelectionStyle.none
        contentView.addSubview(backgroundShape)
        backgroundShape.addSubview(dayLabel)
        backgroundShape.addSubview(daySwitch)
        NSLayoutConstraint.activate([
            backgroundShape.heightAnchor.constraint(equalToConstant: 75),
            backgroundShape.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundShape.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backgroundShape.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundShape.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dayLabel.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: backgroundShape.leadingAnchor, constant: 16),
            
            daySwitch.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor),
            daySwitch.trailingAnchor.constraint(equalTo: backgroundShape.trailingAnchor, constant: -16),
        ])
    }
}
