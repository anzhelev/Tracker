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
    /// gray color for date picker background
    static var grayDatePicker: UIColor {UIColor(named: "YP Date Picker BG") ?? UIColor.lightGray}
    /// main table and collection cells background color
    static var grayCellBackground: UIColor {UIColor(named: "YP Cells Background (Alpha 30)") ?? UIColor.lightGray}
    /// gray color for buttons in inactive state, font color for selected categories, schedule, shevron
    static var grayDisabledButton: UIColor {UIColor(named: "YP Disabled Button") ?? UIColor.gray}
    /// gray color for sells separator
    static var grayCellsSeparator: UIColor {UIColor(named: "YP Table Cells Separator") ?? UIColor.gray}
    /// gray color for tab bar separator
    static var grayTabBarSeparator: UIColor {UIColor(named: "YP Tab Bar Separator (Alpha 30)") ?? UIColor.lightGray}
    /// semi transparent circle for emojis
    static var whiteEmojiCircle: UIColor {UIColor(named: "Emoji Circle (Alpha 30)") ?? UIColor.clear}
    /// gradient color for StatisticsVC
    static var gradientRed: UIColor {UIColor(named: "Gradient1") ?? UIColor.red}
    /// gradient color for StatisticsVC
    static var gradientGreen: UIColor {UIColor(named: "Gradient2") ?? UIColor.green}
    /// gradient color for StatisticsVC
    static var gradientBlue: UIColor {UIColor(named: "Gradient3") ?? UIColor.blue}
    /// background with dark theme support
    static var generalBackground: UIColor {UIColor(named: "TR Background") ?? UIColor.systemBackground}
    /// text with dark theme support
    static var generalTextcolor: UIColor {UIColor(named: "TR TextColor") ?? UIColor.systemBackground}
    /// searchBar background with dark theme support
    static var searchBarBG: UIColor {UIColor(named: "YP SearchBarBG") ?? UIColor.systemBackground}  
}

