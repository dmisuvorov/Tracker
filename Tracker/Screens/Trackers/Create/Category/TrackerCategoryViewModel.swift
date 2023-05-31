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
    
    @Observable
    private (set) var isPlaceholderViewHidden = true
    
    init(selectedCategory: String? = nil) {
        self.selectedCategory = trackersRepository.getTrackerCategoriesByFilter { category in category.name == selectedCategory }.first
    }
    
    func onBindCategoryList() {
        categories = trackersRepository.categories
        checkVisibilityPlaceholder()
        trackersRepository.$categories.bind { [weak self] trackerCategories in
            self?.categories = trackerCategories
            self?.checkVisibilityPlaceholder()
        }
    }
    
    func onSelectNewCategory(category: TrackerCategory?) {
        guard let category = category else { return }
        
        selectedCategory = category
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
    
    private func checkVisibilityPlaceholder() {
        if categories.isEmpty {
            isPlaceholderViewHidden = false
            return
        }
        isPlaceholderViewHidden = true
    }
}
