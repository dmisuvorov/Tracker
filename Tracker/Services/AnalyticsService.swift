//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 01.06.2023.
//
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    private init() { }
    
    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.YandexMetricaApiKey) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func sendEvent(event: String, params: [AnyHashable: Any]? = nil) {
        YMMYandexMetrica.reportEvent(event, parameters: params)
    }
}
