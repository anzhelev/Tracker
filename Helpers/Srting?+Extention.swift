//
//  Srting?+Extention.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.06.2024.
//

import Foundation

extension String? {
    var asSetOfInt: Set<Int>? {
        guard let stringOfInts = self else {
            return nil
        }
        var set: Set<Int> = []
        for char in stringOfInts {
            if let number = char.wholeNumberValue {
                set.insert(number)
            }
        }
        return set
    }
}
