//
//  MockData.swift
//  Tracker
//
//  Created by Andrey Zhelev on 19.05.2024.
//
import Foundation

final class MockData {
    
    // MARK: - Public Properties
    static let storage = MockData()
    var categories: [TrackerCategory] = []
    
    private init() {
        addMockData()
    }
    
    func addMockData() {
        categories = [
            TrackerCategory (category: "Быт",
                             trackers: [
                                Tracker(id: UUID(),
                                        name: "Уборка",
                                        color: .yellow,
                                        emoji: "🧹",
                                        schedule: [7]
                                       ),
                                Tracker(id: UUID(),
                                        name: "Поход в супермаркет",
                                        color: .yellow,
                                        emoji: "🛒",
                                        schedule: [6]
                                       ),
                                Tracker(id: UUID(),
                                        name: "Готовлю еду",
                                        color: .yellow,
                                        emoji: "🍳",
                                        schedule: [1,3,5]
                                       )
                             ]
                            ),
            TrackerCategory (category: "Образование",
                             trackers: [
                                Tracker(id: UUID(),
                                        name: "Учеба на Яндекс Практикуме",
                                        color: .orange,
                                        emoji: "👨🏻‍🎓",
                                        schedule: [1,2,3,4,5,6,7]
                                       ),
                                Tracker(id: UUID(),
                                        name: "Суминар по 14 спринту",
                                        color: .yellow,
                                        emoji: "🧑🏻‍🏫",
                                        schedule: []
                                       )
                             ]
                            ),
            TrackerCategory (category: "Активность",
                             trackers: [
                                Tracker(id: UUID(),
                                        name: "Бассейн",
                                        color: .blue,
                                        emoji: "🏊",
                                        schedule: [2,5]
                                       ),
                                Tracker(id: UUID(),
                                        name: "Фридайвинг",
                                        color: .green,
                                        emoji: "🤿",
                                        schedule: []
                                       ),
                                Tracker(id: UUID(),
                                        name: "Рыбалка",
                                        color: .purple,
                                        emoji: "🎣",
                                        schedule: []
                                       )
                             ]
                            )
        ]
    }
}
