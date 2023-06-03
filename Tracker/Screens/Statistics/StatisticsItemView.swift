//
//  StatisticsItemView.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 02.06.2023.
//

import UIKit

final class StatisticsItemView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fill
        stackView.spacing = 7
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var counterLabel: UILabel = {
        let counterLabel = UILabel()
        counterLabel.font = UIFont.systemFont(ofSize: 34, weight: UIFont.Weight.bold)
        counterLabel.textColor = UIColor.dsColor(dsColor: DSColor.black)
        counterLabel.textAlignment = NSTextAlignment.left
        return counterLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        descriptionLabel.textColor = UIColor.dsColor(dsColor: DSColor.black)
        descriptionLabel.textAlignment = NSTextAlignment.left
        return descriptionLabel
    }()
    
    
    init(description: String, counter: String) {
        super.init(frame: UIScreen.main.bounds)
        stackView.addArrangedSubview(counterLabel)
        stackView.addArrangedSubview(descriptionLabel)
        addSubview(stackView)
        descriptionLabel.text = description
        counterLabel.text = counter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(newCounter: String) {
        counterLabel.text = newCounter
    }
    
    func configureBorder() {
        layer.masksToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        gradient.colors = [
            UIColor.colorFromHex(hexString: "#FD4C49").cgColor,
            UIColor.colorFromHex(hexString: "#46E69D").cgColor,
            UIColor.colorFromHex(hexString: "#007BFA").cgColor,
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1.0
        let bezierPath = UIBezierPath(roundedRect: gradient.frame.insetBy(dx: 1.0, dy: 1.0), cornerRadius: 16)
        shape.path = bezierPath.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}
