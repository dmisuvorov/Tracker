//
//  TabBarController.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 31.03.2023.
//

import UIKit

final class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.dsColor(dsColor: DSColor.dayWhite)
        tabBar.tintColor = UIColor.dsColor(dsColor: DSColor.blue)
    }
    
}
