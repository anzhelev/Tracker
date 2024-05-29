//
//  Tracker.swift
//  Tracker
//
//  Created by Andrey Zhelev on 10.05.2024.
//
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: Int?
    let emoji: Int?
    let schedule: Set<Int>?
}
