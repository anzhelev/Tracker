//
//  TrackersTabViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import Foundation
import UIKit

final class TrackersTabViewController: UIViewController {
    
    // MARK: - Public Properties
    
    
    // MARK: - Private Properties
    private var plusButton: UIButton?
    private let dateToStringFormatter = DateFormatter()
    private var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateToStringFormatter.dateFormat = "dd.MM.yy"
        configureUIElements()
    }
    
    private func configureUIElements() {
        view.backgroundColor = .trWhite
        
        guard let plusButtonImage = UIImage(named: "plusButton") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(self.plusButtonAction))
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = .trBlack
        view.addSubview(plusButton)
        plusButton.accessibilityIdentifier = "plusButton"
        self.plusButton = plusButton
        
        let dateSelector = UIDatePicker()
        dateSelector.calendar = .autoupdatingCurrent
        dateSelector.datePickerMode = .date
        let minDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        dateSelector.minimumDate = minDate
        dateSelector.maximumDate = maxDate
        if let localeID = Locale.preferredLanguages.first {
            dateSelector.locale = Locale(identifier: localeID)
        }
        dateSelector.layer.masksToBounds = true
        dateSelector.layer.cornerRadius = 8
        dateSelector.backgroundColor = .trDateButtonBackground
        dateSelector.addTarget(self, action: #selector(dateSelectorChanged(datePicker:)), for: .valueChanged)
        //        dateSelector.tintColor = .trBlackr
        dateSelector.setDate(Date(), animated: true)
        dateSelector.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateSelector)
        
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: "SFPro-Bold", size: 34)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let searchField = UISearchTextField()
        searchField.borderStyle = .roundedRect
        searchField.font = UIFont(name: "SFPro-Regular", size: 17)
        searchField.placeholder = "Поиск"
        searchField.textColor = .trBlack
        searchField.tintColor = .trSearchFieldText
        searchField.backgroundColor = .trWhite
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        
        let picture = UIImage(named: "tabTrackersImage")
        let pictueInCenterView = UIImageView(image: picture)
        pictueInCenterView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pictueInCenterView)
        
        let questionLabel = UILabel()
        questionLabel.text = "Что будем отслеживать?"
        questionLabel.font = UIFont(name: "SFPro-Regular", size: 12)
        questionLabel.textColor = .trBlack
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            dateSelector.heightAnchor.constraint(equalToConstant: 34),
            dateSelector.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            dateSelector.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateSelector.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
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
    }
    
    @objc func dateSelectorChanged(datePicker: UIDatePicker) {
        selectedDate = datePicker.date
        print("CONSOLE: dateSelectorChanged", selectedDate)
    }
}
