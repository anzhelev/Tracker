//
//  Date+Extention.swift
//  Tracker
//
//  Created by Andrey Zhelev on 28.06.2024.
//

import Foundation

extension Date {
    var short: Date {Calendar.current.startOfDay(for: self)}
}
