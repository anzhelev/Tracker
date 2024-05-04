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
    private var dateAdjustmentButton: UIButton?
    private var dateAdjustmentButtonTitle: String = ""
    private let dateToStringFormatter = DateFormatter()
    
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
        //        userLogoutButton.tintColor = .igRed
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = .trBlack
        view.addSubview(plusButton)
        plusButton.accessibilityIdentifier = "plusButton"
        self.plusButton = plusButton
        
        
        let dateAdjustmentButton = UIButton()
        let dateAdjustmentButtonTitle = "  \(dateToStringFormatter.string(from: Date()))  "
        dateAdjustmentButton.backgroundColor = .trDateButtonBackground
        dateAdjustmentButton.setTitleColor(.trBlack, for: .normal)
        dateAdjustmentButton.setTitle(dateAdjustmentButtonTitle, for: .normal)
        dateAdjustmentButton.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17)
        dateAdjustmentButton.layer.masksToBounds = true
        dateAdjustmentButton.layer.cornerRadius = 8
        dateAdjustmentButton.addTarget(self, action: #selector(self.dateAdjustmentButtonAction), for: .touchUpInside)
        dateAdjustmentButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateAdjustmentButton)
        dateAdjustmentButton.accessibilityIdentifier = "dateAdjustmentButton"
        self.dateAdjustmentButton = dateAdjustmentButton
        self.dateAdjustmentButtonTitle = dateAdjustmentButtonTitle
        
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
//        searchField.backgroundColor = .trWhite
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
            
            dateAdjustmentButton.heightAnchor.constraint(equalToConstant: 34),
            dateAdjustmentButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 90),
            dateAdjustmentButton.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            dateAdjustmentButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
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
    /// действие по нажатию кнопки выхода из профиля
    @objc func plusButtonAction() {
        print("CONSOLE: plusButtonAction" )
    }
    
    /// действие по нажатию кнопки выхода из профиля
    @objc func dateAdjustmentButtonAction() {
        print("CONSOLE: dateAdjustmentButtonAction" )
        self.dateAdjustmentButton?.setTitle("new title", for: .normal)
    }
    
}
