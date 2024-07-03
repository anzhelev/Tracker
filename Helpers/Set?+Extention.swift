//
//  Set?+Extention.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.06.2024.
//
import Foundation

extension Set<Int>? {
    var asString: String? {
        guard let setOfInts = self else {
            return nil
        }
        var stringOfInts: String = ""
        for number in setOfInts {
            stringOfInts.append(String(number))
        }
        return stringOfInts
    }
}
