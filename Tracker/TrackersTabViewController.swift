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
    private let datePicker: UIDatePicker = UIDatePicker()
    private var selectedDate = Date()
    private var dateTextField = UITextField()
    private let datePickerToolBar = UIToolbar()
    private var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateToStringFormatter.dateFormat = "dd.MM.yy"
        setupDatePicker()
        setupDatePickerToolBar()
        setupTapGesture()
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
        
        let dateTextField = UITextField()
        dateTextField.text = "\(dateToStringFormatter.string(from: selectedDate))"
        dateTextField.textAlignment = .center
        dateTextField.textColor = .trBlack
        dateTextField.font = UIFont(name: "SFPro-Regular", size: 17)
        dateTextField.borderStyle = .none
        dateTextField.layer.masksToBounds = true
        dateTextField.layer.cornerRadius = 8
        dateTextField.backgroundColor = .trDateButtonBackground
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTextField)
        dateTextField.accessibilityIdentifier = "dateTextField"
        self.dateTextField = dateTextField
        self.dateTextField.inputView = self.datePicker
        self.dateTextField.inputAccessoryView = datePickerToolBar
        
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
            
            dateTextField.heightAnchor.constraint(equalToConstant: 34),
            dateTextField.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            dateTextField.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            dateTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
    
    private func setupDatePicker() {
        let minDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.calendar = .autoupdatingCurrent
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
    }
    
    private func setupDatePickerToolBar() {
        datePickerToolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.closeDatePicker))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        doneButton.tintColor = .trBlack
        datePickerToolBar.setItems([flexSpace, doneButton], animated: true)
    }
    
    private func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureDone))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.isEnabled = false
    }
    
    @objc func closeDatePicker() {
        view.endEditing(true)
        tapGesture.isEnabled = false
    }
    
    @objc func tapGestureDone() {
        closeDatePicker()
    }
    
    @objc func datePickerChanged(datePicker: UIDatePicker) {
        tapGesture.isEnabled = true
        selectedDate = datePicker.date
        dateTextField.text = "\(dateToStringFormatter.string(from: selectedDate))"
    }
}
