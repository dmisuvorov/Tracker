//
//  ColorViewCell.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 25.04.2023.
//

import UIKit

final class ColorViewCell : UICollectionViewCell {
    static let identifier = "ColorViewCell"
    
    var currentColorString: String? = nil
    
    private lazy var backgroundShape: UIView = {
        let backgroundShape = UIView()
        backgroundShape.layer.masksToBounds = true
        backgroundShape.layer.cornerRadius = 8
        backgroundShape.clipsToBounds = true
        backgroundShape.isHidden = true
        backgroundShape.translatesAutoresizingMaskIntoConstraints = false
        return backgroundShape
    }()
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8
        colorView.clipsToBounds = true
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    private var currentColor: UIColor {
        return colorView.backgroundColor ?? UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("There is no storyboard")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func bindCell(color: String, isSelected: Bool = false) {
        let uiColor = UIColor(named: color) ?? .clear
        currentColorString = color
        colorView.backgroundColor = uiColor
        if isSelected {
            selectCell()
            return
        }
        unselectCell()
    }
    
    func selectCell() {
        backgroundShape.layer.backgroundColor = currentColor.withAlphaComponent(0.3).cgColor
        backgroundShape.isHidden = false
    }
    
    func unselectCell() {
        backgroundShape.isHidden = true
    }
    
    private func configureUI() {
        addSubview(backgroundShape)
        addSubview(colorView)
        NSLayoutConstraint.activate([
            backgroundShape.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundShape.topAnchor.constraint(equalTo: topAnchor),
            backgroundShape.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundShape.bottomAnchor.constraint(equalTo: bottomAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: backgroundShape.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: backgroundShape.centerYAnchor)
        ])
    }
}
