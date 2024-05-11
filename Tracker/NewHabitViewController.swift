//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 11.05.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    
    weak var delegate: NewTrackerCreationVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
        
    }
      
    private func configureUIElements() {
        view.backgroundColor = .trWhite
        
        let titleLabel = UILabel()
        titleLabel.text = "Новая привычка"
        titleLabel.font = UIFont(name: "SFPro-Semibold", size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
//        let newHabitCreationButton = UIButton()
//        newHabitCreationButton.backgroundColor = .trBlack
//        newHabitCreationButton.setTitle("Привычка", for: .normal)
//        newHabitCreationButton.addTarget(self, action: #selector(switchToNewHabitViewController), for: .touchUpInside)
//        newHabitCreationButton.setTitleColor(.trWhite, for: .normal)
//        newHabitCreationButton.titleLabel?.font = UIFont(name: "SFPro-Semibold", size: 16)
//        newHabitCreationButton.layer.masksToBounds = true
//        newHabitCreationButton.layer.cornerRadius = 16
//        newHabitCreationButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(newHabitCreationButton)
//        
//        let newEventCreationButton = UIButton()
//        newEventCreationButton.backgroundColor = .trBlack
//        newEventCreationButton.setTitle("Нерегулярное событие", for: .normal)
//        newEventCreationButton.addTarget(self, action: #selector(switchToNewEventViewController), for: .touchUpInside)
//        newEventCreationButton.setTitleColor(.trWhite, for: .normal)
//        newEventCreationButton.titleLabel?.font = UIFont(name: "SFPro-Semibold", size: 16)
//        newEventCreationButton.layer.masksToBounds = true
//        newEventCreationButton.layer.cornerRadius = 16
//        newEventCreationButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(newEventCreationButton)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
            
//            newHabitCreationButton.heightAnchor.constraint(equalToConstant: 60),
//            newHabitCreationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
//            newHabitCreationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            newHabitCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            
//            newEventCreationButton.heightAnchor.constraint(equalToConstant: 60),
//            newEventCreationButton.topAnchor.constraint(equalTo: newHabitCreationButton.bottomAnchor, constant: 16),
//            newEventCreationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            newEventCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
}
