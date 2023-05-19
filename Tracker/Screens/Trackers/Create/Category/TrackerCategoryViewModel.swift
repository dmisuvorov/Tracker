//
//  TrackerCategoryListViewModel.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 14.05.2023.
//


final class TrackerCategoryViewModel {
    private let trackersRepository = TrackersRepository.shared
    
    @Observable
    private (set) var categories: [TrackerCategory] = []
    
    @Observable
    private (set) var selectedCategory: TrackerCategory?
    
    @Observable
    private (set) var currentNewCategoryName: String = ""
    
    init(selectedCategory: TrackerCategory? = nil) {
        self.selectedCategory = selectedCategory
    }
    
    func onBindCategoryList() {
        categories = trackersRepository.categories
        trackersRepository.$categories.bind { [weak self] trackerCategories in
            self?.categories = trackerCategories
        }
    }
    
    func onSelectNewCategory(category: TrackerCategory?) {
        guard let category = category else { return }
        
        self.selectedCategory = category
    }
    
    func onChangeNewTrackerCategoryName(currentNewCategoryName: String?) {
        guard let currentNewCategoryName = currentNewCategoryName else { return }
        
        self.currentNewCategoryName = currentNewCategoryName
    }
    
    func onCreateNewCategoryButtonClick() {
        if !currentNewCategoryName.isEmpty {
            trackersRepository.addCategory(categoryName: currentNewCategoryName)
        }
    }
}
