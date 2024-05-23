//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import Foundation
import UIKit

final class TrackersViewController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Public Properties
    
    
    // MARK: - Private Properties
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    
    private var plusButton = UIButton()
    private let dateFormatter = DateFormatter()
    private var selectedDate = Date()
    private var dateLabel = UILabel()
    private var stubView = UIView()
    private var titleLabel = UILabel()
    private var searchBar = UISearchBar()
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let mock = MockData.storage
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = mock.categories
        dateFormatter.dateFormat = "dd.MM.yy"
        
        configureUIElements()
    }
   
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        
        setPlusButton()
        setDatePicker()
        setTitleLabel()
        setSearchBar()
        setStubImage()
        updateStub()
//        searchBar.setShowsCancelButton(false, animated: false)
    }

    
    
    private func setPlusButton() {
        guard let plusButtonImage = UIImage(named: "plusButton") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(self.plusButtonAction))
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = Colors.black
        view.addSubview(plusButton)
        plusButton.accessibilityIdentifier = "plusButton"
        self.plusButton = plusButton
        
        NSLayoutConstraint.activate([
            plusButton.heightAnchor.constraint(equalToConstant: 44),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            plusButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    private func setDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        let minDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())
        let maxDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        datePicker.tintColor = Colors.blue
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.font = UIFont(name: SFPro.regular, size: 17)
        dateLabel.text = getFormattedString(from: Date())
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = Colors.grayDatePicker
        dateLabel.textColor = .black
        dateLabel.isUserInteractionEnabled = true
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 8
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel = dateLabel
        
        view.addSubview(datePicker)
        datePicker.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            datePicker.heightAnchor.constraint(equalToConstant: 34),
            datePicker.widthAnchor.constraint(equalToConstant: 80),
            datePicker.centerYAnchor.constraint(equalTo: plusButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalTo: datePicker.heightAnchor),
            dateLabel.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor)
        ])
    }
    
    private func setTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: SFPro.bold, size: 34)
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0)
        ])
    }
        
    private func setSearchBar() {
        let searchField = UISearchBar()
        searchField.placeholder = "Поиск"
        searchField.showsCancelButton = true
        searchField.layer.cornerRadius = 8
        searchField.layer.masksToBounds = true
        searchField.searchTextField.font = UIFont(name: SFPro.regular, size: 17)
        searchField.searchTextField.textColor = .ypBlack
        searchField.searchBarStyle = .minimal
        searchField.enablesReturnKeyAutomatically = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Отмена"
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        self.searchBar = searchField
        
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 36),
            searchField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
       
    private func setStubImage() {
        let stubView = UIView()
        stubView.backgroundColor = .none
        stubView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stubView)
        self.stubView = stubView
        
        let image = UIImage(named: "tabTrackersImage")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubImageView)
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = UIFont(name: SFPro.regular, size: 12)
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(label)
        
        NSLayoutConstraint.activate([
            stubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stubView.heightAnchor.constraint(equalToConstant: 110),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.bottomAnchor.constraint(equalTo: stubView.centerYAnchor),
            stubImageView.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            label.heightAnchor.constraint(equalToConstant: 18),
            label.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: stubView.centerXAnchor)
        ])
    }
    

    private func setTrackersCollectionView() {
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.backgroundColor = Colors.white
        
        trackersCollectionView.register(TrackersCVCell.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(TrackersCVHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")

        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 34),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        selectedDate = datePicker.date
        dateLabel.text = getFormattedString(from: selectedDate)
        print("CONSOLE: dateSelectorChanged", selectedDate)
    }
    
    private func getFormattedString(from date: Date) -> String {
        return dateFormatter.string(from: date)
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
    
    private func updateStub() {
        //        self.stubView.isHidden = !self.categories.isEmpty
        //        self.categoriesTableView.isHidden = self.categories.isEmpty
    }
    
    private func addNew(record: TrackerRecord) {
        
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
}

extension TrackersViewController: UICollectionViewDelegate {
    
}
