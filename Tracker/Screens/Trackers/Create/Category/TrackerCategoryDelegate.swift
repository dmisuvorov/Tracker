//
//  TrackerCategoryDelegate.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 19.05.2023.
//

protocol TrackerCategoryDelegate : AnyObject {
    
    func onSelectCategory(selectedCategory: TrackerCategory)
    
}
