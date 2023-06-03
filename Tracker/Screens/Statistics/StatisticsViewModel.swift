//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 02.06.2023.
//

final class StatisticsViewModel {
    private let trackersRepository = TrackersRepository.shared
    
    @Observable
    private (set) var isPlaceholderViewHidden = true
    
    @Observable
    private (set) var bestPeriodValue = 0
    
    @Observable
    private (set) var bestDaysValue = 0
    
    @Observable
    private (set) var completedTrackersValue = 0
    
    @Observable
    private (set) var averageValue = 0
    
    
    func onViewDidLoad() {
        observeCompletedTrackers()
        observeBestPeriod()
        observeBestDays()
        observeAverageValue()
        
        checkNeedShowStatisitics()
    }
    
    private func observeCompletedTrackers() {
        completedTrackersValue = trackersRepository.completedTrackers.count
        trackersRepository.$completedTrackers.bind { [weak self] completedTrackers in
            self?.completedTrackersValue = completedTrackers.count
            self?.checkNeedShowStatisitics()
        }
    }
    
    private func checkNeedShowStatisitics() {
        if bestPeriodValue == 0 && bestDaysValue == 0 && completedTrackersValue == 0 && averageValue == 0 {
            isPlaceholderViewHidden = false
            return
        }
        isPlaceholderViewHidden = true
    }
    
    private func observeBestPeriod() {
        //TODO
    }
    
    private func observeBestDays() {
        //TODO
    }
    
    private func observeAverageValue() {
        //TODO
    }
}
