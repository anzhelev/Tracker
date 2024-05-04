//
//  ViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 03.05.2024.
//

import UIKit

class LaunchScreen: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        sleep(5)
        switchToTabBarController()
    }
    
    private func configureUIElements() {
        view.backgroundColor = .trLSBackground
        let appLogoImage = UIImage(named: "launchScreenLogo")
        let appLogoImageView = UIImageView(image: appLogoImage)
        appLogoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appLogoImageView)
        
        NSLayoutConstraint.activate([
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

