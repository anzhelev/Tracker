//
//  CellParams.swift
//  Tracker
//
//  Created by Andrey Zhelev on 03.08.2024.
//
import Foundation

struct CellParams {
    let id: CellID
    let reuseID: ReuseID
    var cellHeight: CGFloat
    let rounded: RoundedCorners
    let separator: Bool
    let title: String
    var value: String? = nil
}
