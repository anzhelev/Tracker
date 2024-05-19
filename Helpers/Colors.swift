//
//  UIColor+Extensions.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

/// Custom colors
enum Colors {
/// launch screen background, switch tint color
    static var blue: UIColor {UIColor(named: "YP Blue") ?? UIColor.blue}
    /// main font color
    static var black: UIColor {UIColor(named: "YP Black") ?? UIColor.black}
    /// main views, tables and collections background color, font color
    static var white: UIColor {UIColor(named: "YP White") ?? UIColor.white}
    /// new tracker creation cancel button font and border color
    static var red: UIColor {UIColor(named: "YP Red") ?? UIColor.red}
    /// main table and collection cells background color
    static var grayCellBackground: UIColor {UIColor(named: "YP Cells Background (Alpha 30)") ?? UIColor.lightGray}
    /// gray color for buttons in inactive state, font color for selected categories, schedule, shevron
    static var grayDisabledButton: UIColor {UIColor(named: "YP Disabled Button") ?? UIColor.gray}
    /// gray color for sells separator
    static var grayCellsSeparator: UIColor {UIColor(named: "YP Table Cells Separator (Alpha 80)") ?? UIColor.gray}
    /// gray color for tab bar separator
    static var grayTabBarSeparator: UIColor {UIColor(named: "YP Tab Bar Separator (Alpha 30)") ?? UIColor.lightGray}
}
