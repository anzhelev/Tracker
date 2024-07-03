//
//  ScheduleValueTransformer.swift
//  Tracker
//
//  Created by Andrey Zhelev on 25.06.2024.
//

import Foundation

@objc
class ScheduleValueTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let schedule = value as? [Int]? else {return nil}
        return try? JSONEncoder().encode(schedule)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else {return nil}
        return try? JSONDecoder().decode([Int]?.self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            ScheduleValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: ScheduleValueTransformer.self))
        )
    }
}
