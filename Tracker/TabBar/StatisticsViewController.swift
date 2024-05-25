//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        view.backgroundColor = Colors.white
    }
}
