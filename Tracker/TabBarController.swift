//
//  TabBarController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpperLine()
        setupBars()
    }
    
    private func setupBars() {
        
        let trackersTabViewController = TrackersTabViewController()
        trackersTabViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(named: "tabBarTrackersTab"),
            selectedImage: nil
        )
        
        let statisticsTabViewController = StatisticsTabViewController()
        statisticsTabViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "tabBarStatisticsTab"),
            selectedImage: nil
        )
        self.viewControllers = [trackersTabViewController, statisticsTabViewController]
    }
    
    private func setUpperLine () {
        //        tabBar.layer.borderWidth = 0.50
        //        tabBar.clipsToBounds = true
        let upperLine = UIView()
        upperLine.backgroundColor = .trTabBarUpperlineAlpha30
        upperLine.translatesAutoresizingMaskIntoConstraints = false
        self.tabBar.addSubview(upperLine)
        
        NSLayoutConstraint.activate([
            upperLine.heightAnchor.constraint(equalToConstant: 0.5),
            upperLine.topAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.topAnchor, constant: 0),
            upperLine.leadingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            upperLine.trailingAnchor.constraint(equalTo: tabBar.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}
