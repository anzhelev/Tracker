//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Andrey Zhelev on 25.07.2024.
//
import Foundation
import YandexMobileMetrica

enum Events: String {
    case open = "screen opened"
    case close = "screen closed"
    case click = "button pressed"
}

enum Screens: String {
    case main = "Main"
}

enum EventItems: String {
    case addTrack = "addTrack"
    case track = "track"
    case filter = "filter"
    case edit = "edit"
    case delete = "delete"
}

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "8afa22c2-6d70-4e39-b14a-3da538769337") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: Events, screen: Screens, item: EventItems? = nil) {
        
        let params = event == .click
        ? ["screen" : screen.rawValue, "item" : item?.rawValue ?? ""]
        : ["screen" : screen.rawValue]
        
        YMMYandexMetrica.reportEvent(event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
        
        print("@@@ AnalyticsService report sent:", event.rawValue, screen.rawValue, item?.rawValue ?? "")
    }
}
