//
//  TabBarController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.generalBackground
        setUpperLine()
        setupBars()
    }
    
    private func setupBars() {        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackersViewController.title", comment: ""),
            image: UIImage(named: "tabBarTrackersTab"),
            selectedImage: nil
        )
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statisticsViewController.title", comment: ""),
            image: UIImage(named: "tabBarStatisticsTab"),
            selectedImage: nil
        )
        self.viewControllers = [trackersViewController, statisticsViewController]
    }
    
    private func setUpperLine () {
        let upperLine = UIView()
        upperLine.backgroundColor = Colors.grayTabBarSeparator
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
