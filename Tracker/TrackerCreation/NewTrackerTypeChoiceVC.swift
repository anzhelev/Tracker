//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 11.05.2024.
//
import UIKit

final class NewTrackerTypeChoiceVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: TrackersViewController?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }
    
    // MARK: - IBAction
    @objc private func createNewHabit() {
        guard let superDelegate = self.delegate else {
            return
        }
        let vc = TrackerCreationVC(newTrackerType: .habit, delegate: superDelegate, editModeParams: nil)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    @objc private func createNewEvent() {
        guard let superDelegate = self.delegate else {
            return
        }
        let vc = TrackerCreationVC(newTrackerType: .event, delegate: superDelegate, editModeParams: nil)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("newTrackerTypeChoiceVC.title", comment: "")
        titleLabel.font = Fonts.SFPro16Medium
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let newHabitCreationButton = UIButton()
        newHabitCreationButton.backgroundColor = Colors.black
        newHabitCreationButton.setTitle(NSLocalizedString("newTrackerTypeChoiceVC.habit", comment: ""), for: .normal)
        newHabitCreationButton.addTarget(self, action: #selector(createNewHabit), for: .touchUpInside)
        newHabitCreationButton.setTitleColor(Colors.white, for: .normal)
        newHabitCreationButton.titleLabel?.font = Fonts.SFPro16Medium
        newHabitCreationButton.layer.masksToBounds = true
        newHabitCreationButton.layer.cornerRadius = 16
        newHabitCreationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newHabitCreationButton)
        
        let newEventCreationButton = UIButton()
        newEventCreationButton.backgroundColor = Colors.black
        newEventCreationButton.setTitle(NSLocalizedString("newTrackerTypeChoiceVC.event", comment: ""), for: .normal)
        newEventCreationButton.addTarget(self, action: #selector(createNewEvent), for: .touchUpInside)
        newEventCreationButton.setTitleColor(Colors.white, for: .normal)
        newEventCreationButton.titleLabel?.font = Fonts.SFPro16Medium
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
}
