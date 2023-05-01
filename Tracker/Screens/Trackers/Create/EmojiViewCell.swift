//
//  EmojiViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 24.04.2023.
//

import UIKit

final class EmojiViewCell: UICollectionViewCell {
    static let identifier = "EmojiViewCell"
    
    private lazy var backgroundShape: UIView = {
        let backgroundShape = UIView()
        backgroundShape.layer.masksToBounds = true
        backgroundShape.layer.cornerRadius = 16
        backgroundShape.clipsToBounds = true
        backgroundShape.backgroundColor = UIColor.dsColor(dsColor: DSColor.lightGray)
        backgroundShape.isHidden = true
        backgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return backgroundShape
    }()
    
    private lazy var emojiLabel: UILabel = {
        let emojiLabel = UILabel()
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
        emojiLabel.textAlignment = NSTextAlignment.center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        return emojiLabel
    }()
    
    var currentEmoji: String {
        return emojiLabel.text ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func bindCell(emoji: String, isSelected: Bool = false) {
        emojiLabel.text = emoji
        if isSelected {
            selectCell()
            return
        }
        unselectCell()
    }
    
    func selectCell() {
        backgroundShape.isHidden = false
    }
    
    func unselectCell() {
        backgroundShape.isHidden = true
    }
    
    private func configureUI() {
        addSubview(backgroundShape)
        addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            backgroundShape.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundShape.topAnchor.constraint(equalTo: topAnchor),
            backgroundShape.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundShape.bottomAnchor.constraint(equalTo: bottomAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: backgroundShape.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor)
        ])
    }
}
