//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 13.04.2023.
//

import UIKit

final class TrackerViewCell : UICollectionViewCell {
    weak var delegate: TrackersViewProtocol?
    static let identifier = "TrackerCell"
    
    private (set) var isPinned: Bool = false
    private (set) var trackerId: UUID? = nil
    
    private lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.tintColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = 17
        addButton.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(onAddButtonClick), for: UIControl.Event.touchUpInside)
        return addButton
    }()
    
    private lazy var backgroundShape: UIView = {
        let backgroundShape = UIView()
        backgroundShape.layer.masksToBounds = true
        backgroundShape.layer.cornerRadius = 16
        backgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return backgroundShape
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 12)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    private lazy var emojiBackgroundShape: UIView = {
        let emojiBackgroundShape = UIView()
        emojiBackgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite).withAlphaComponent(0.3)
        emojiBackgroundShape.layer.masksToBounds = true
        emojiBackgroundShape.layer.cornerRadius = 12
        emojiBackgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return emojiBackgroundShape
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.font = UIFont.systemFont(ofSize: 12)
        dayLabel.textColor = UIColor.dsColor(dsColor: DSColor.dayBlack)
        dayLabel.numberOfLines = 1
        dayLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(backgroundShape)
        contentView.addSubview(dayLabel)
        contentView.addSubview(addButton)
        backgroundShape.addSubview(emojiBackgroundShape)
        backgroundShape.addSubview(titleLabel)
        emojiBackgroundShape.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            backgroundShape.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundShape.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundShape.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.topAnchor.constraint(equalTo: backgroundShape.bottomAnchor, constant: 8),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            dayLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            emojiBackgroundShape.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundShape.heightAnchor.constraint(equalToConstant: 24),
            emojiBackgroundShape.topAnchor.constraint(equalTo: backgroundShape.topAnchor, constant: 12),
            emojiBackgroundShape.leadingAnchor.constraint(equalTo: backgroundShape.leadingAnchor, constant: 12),
            
            titleLabel.leadingAnchor.constraint(equalTo: backgroundShape.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundShape.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: backgroundShape.bottomAnchor, constant: -12),
            
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundShape.centerYAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundShape.centerXAnchor),
        ])
    }
    
    @objc func onAddButtonClick() {
        delegate?.onTrackerCellButtonClick(trackerCell: self)
    }
    
    func bindCell(tracker: TrackerView) {
        trackerId = tracker.id
        isPinned = tracker.isPinned
        titleLabel.text = tracker.name
        dayLabel.text = tracker.daysCompleted
        emojiLabel.text = tracker.emoji
        let backgroundColor = UIColor(named: tracker.color) ?? UIColor.dsColor(dsColor: DSColor.blue)
        backgroundShape.backgroundColor = backgroundColor
        
        if tracker.isDoneInCurrentDate {
            addButton.setImage(UIImage(systemName: "checkmark"), for: UIControl.State.normal)
            addButton.backgroundColor = backgroundColor.withAlphaComponent(0.3)
            return
        }
        addButton.setImage(UIImage(systemName: "plus"), for: UIControl.State.normal)
        addButton.backgroundColor = backgroundColor
    }
}
