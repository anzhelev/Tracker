//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import Foundation
import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    
    
    // MARK: - Private Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private var plusButton: UIButton?
    private let dateToStringFormatter = DateFormatter()
    private var selectedDate = Date()
    private let mock = MockData.storage
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = mock.categories
        dateToStringFormatter.dateFormat = "dd.MM.yy"
        configureUIElements()
    }
    
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        
        guard let plusButtonImage = UIImage(named: "plusButton") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(self.plusButtonAction))
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = Colors.black
        view.addSubview(plusButton)
        plusButton.accessibilityIdentifier = "plusButton"
        self.plusButton = plusButton
        
        let dateSelector = UIDatePicker()
        dateSelector.datePickerMode = .date
        let minDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        dateSelector.minimumDate = minDate
        dateSelector.maximumDate = maxDate
        dateSelector.tintColor = Colors.black
        dateSelector.locale = Locale(identifier: "ru_RU")
        dateSelector.layer.masksToBounds = true
        dateSelector.layer.cornerRadius = 8
        dateSelector.addTarget(self, action: #selector(dateSelectorChanged(datePicker:)), for: .valueChanged)
        dateSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateSelector)
        
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: SFPro.bold, size: 34)
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let searchField = UISearchTextField()
        searchField.borderStyle = .roundedRect
        searchField.font = UIFont(name: SFPro.regular, size: 17)
        searchField.placeholder = "Поиск"
        searchField.textColor = Colors.black
        searchField.backgroundColor = .clear
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        
        let picture = UIImage(named: "tabTrackersImage")
        let pictueInCenterView = UIImageView(image: picture)
        pictueInCenterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pictueInCenterView)
        
        let questionLabel = UILabel()
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.font = UIFont(name: SFPro.regular, size: 12)
        questionLabel.textColor = Colors.black
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            dateSelector.heightAnchor.constraint(equalToConstant: 34),
            dateSelector.widthAnchor.constraint(equalToConstant: 110),
            dateSelector.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateSelector.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0),
            
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            pictueInCenterView.heightAnchor.constraint(equalToConstant: 80),
            pictueInCenterView.widthAnchor.constraint(equalToConstant: 80),
            pictueInCenterView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            pictueInCenterView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            questionLabel.heightAnchor.constraint(equalToConstant: 18),
            questionLabel.topAnchor.constraint(equalTo: pictueInCenterView.bottomAnchor, constant: 8),
            questionLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    // MARK: - IBAction
    /// действие по нажатию кнопки "＋"
    @objc func plusButtonAction() {
        print("CONSOLE: plusButtonAction" )
        let newTrackerCreationVC = NewTrackerTypeChoiceVC()
        newTrackerCreationVC.delegate = self
        let newTrackerNavigation = UINavigationController(rootViewController: newTrackerCreationVC)
        present(newTrackerNavigation, animated: true)
    }
    
    @objc func dateSelectorChanged(datePicker: UIDatePicker) {
        selectedDate = datePicker.date
        print("CONSOLE: dateSelectorChanged", selectedDate)
    }
    
    func addNew(tracker: Tracker, to category: String) {
        var newCategories: [TrackerCategory] = []
        var existingCategories: Set<String> = []
        
        for item in categories {
            existingCategories.insert(item.category)
            if item.category != category {
                newCategories.append(item)
            } else {
                var trackers: [Tracker] = item.trackers
                trackers.append(tracker)
                newCategories.append(TrackerCategory(category: category,
                                                     trackers: trackers
                                                    )
                )
            }
        }
        
        if !existingCategories.contains(category) {
            let trackers: [Tracker] = [tracker]
            newCategories.append(TrackerCategory(category: category,
                                                 trackers: trackers
                                                )
            )
        }
        self.categories = newCategories
    }
    
    func updateCategories(with newlist: Set<String>) {
        var existingCategories: Set<String> = []
        
        for item in categories {
            existingCategories.insert(item.category)
        }
        let newCategories = newlist.subtracting(existingCategories)
        
        for item in newCategories {
            let trackers: [Tracker] = []
            categories.append(TrackerCategory(category: item,
                                              trackers: trackers
                                             )
            )
        }
    }
    
    private func addNew(record: TrackerRecord) {
        
    }
}
