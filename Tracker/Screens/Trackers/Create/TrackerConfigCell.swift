//
//  TrackerConfigCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 10.04.2023.
//

import UIKit

final class TrackerConfigCell : UIView {
    private var onClickAction: (() -> Void)? = nil
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.dsColor(dsColor: DSColor.black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.textColor = UIColor.dsColor(dsColor: DSColor.gray)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        return subtitleLabel
    }()
    
    private lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView()
        labelStackView.axis = NSLayoutConstraint.Axis.vertical
        labelStackView.spacing = 2
        labelStackView.alignment = UIStackView.Alignment.leading
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var chevronIcon: UIImageView = {
        let chevronIcon = UIImageView(image: UIImage(named: "ChevronIcon"))
        chevronIcon.tintColor = UIColor.dsColor(dsColor: DSColor.gray)
        chevronIcon.translatesAutoresizingMaskIntoConstraints = false
        return chevronIcon
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor.dsColor(dsColor: DSColor.gray)
        divider.isHidden = true
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    init(
        title: String,
        subtitle: String? = nil,
        hasDivider: Bool = false,
        onClick: @escaping () -> Void = {}
    ) {
        super.init(frame: CGRect.zero)
        layer.masksToBounds = true
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = UIColor.dsColor(dsColor: DSColor.background)
        
        labelStackView.addArrangedSubview(titleLabel)
        addSubview(labelStackView)
        addSubview(chevronIcon)
        addSubview(divider)
        titleLabel.text = title
        divider.isHidden = !hasDivider
        updateSubtitle(subtitle: subtitle)
        
        NSLayoutConstraint.activate([
            chevronIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trailingAnchor.constraint(equalTo: chevronIcon.trailingAnchor, constant: 24),
            leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -16),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        onClickAction = onClick
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCellClick))
        addGestureRecognizer(tapGesture)
    }
    
    func showDivider() {
        divider.isHidden = false
    }
    
    func updateSubtitle(subtitle: String?) {
        let isHidden = subtitle == nil || subtitle == ""
        subtitleLabel.isHidden = isHidden
        subtitleLabel.text = subtitle
        if isHidden {
            labelStackView.removeArrangedSubview(subtitleLabel)
            return
        }
        labelStackView.addArrangedSubview(subtitleLabel)
    }
    
    @objc private func onCellClick() {
        onClickAction?()
    }
}
