//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 11.05.2024.
//

import UIKit

final class NewTrackerTypeChoiceVC: UIViewController {
    
    weak var delegate: TrackersViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }
    
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        
        let titleLabel = UILabel()
        titleLabel.text = "Создание трекера"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let newHabitCreationButton = UIButton()
        newHabitCreationButton.backgroundColor = Colors.black
        newHabitCreationButton.setTitle("Привычка", for: .normal)
        newHabitCreationButton.addTarget(self, action: #selector(createNewHabit), for: .touchUpInside)
        newHabitCreationButton.setTitleColor(Colors.white, for: .normal)
        newHabitCreationButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        newHabitCreationButton.layer.masksToBounds = true
        newHabitCreationButton.layer.cornerRadius = 16
        newHabitCreationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newHabitCreationButton)
        
        let newEventCreationButton = UIButton()
        newEventCreationButton.backgroundColor = Colors.black
        newEventCreationButton.setTitle("Нерегулярное событие", for: .normal)
        newEventCreationButton.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
        newEventCreationButton.setTitleColor(Colors.white, for: .normal)
        newEventCreationButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        newEventCreationButton.layer.masksToBounds = true
        newEventCreationButton.layer.cornerRadius = 16
        newEventCreationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newEventCreationButton)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            newHabitCreationButton.heightAnchor.constraint(equalToConstant: 60),
            newHabitCreationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            newHabitCreationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newHabitCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            newEventCreationButton.heightAnchor.constraint(equalToConstant: 60),
            newEventCreationButton.topAnchor.constraint(equalTo: newHabitCreationButton.bottomAnchor, constant: 16),
            newEventCreationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newEventCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
            
        ])
    }
    
    @objc private func createNewHabit() {
        guard let superDelegate = self.delegate else {
            return
        }
        let vc = NewTrackerCreationVC(newTrackerType: .habit, delegate: self, superDelegate: superDelegate)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    @objc private func createNewEvent() {
        guard let superDelegate = self.delegate else {
            return
        }
        let vc = NewTrackerCreationVC(newTrackerType: .event, delegate: self, superDelegate: superDelegate)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
}
