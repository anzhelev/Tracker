//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    var selectedDate = Date().short
    var selectedWeekDay: Int = Calendar.current.component(.weekday, from: Date())
    lazy var storeService = StoreService(delegate: self)
    
    // MARK: - Private Properties
    private var plusButton = UIButton()
    private let dateFormatter = DateFormatter()
    private var datePicker = UIDatePicker()
    private var dateLabel = UILabel()
    private var stubView = UIView()
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    private var titleLabel = UILabel()
    private var searchBarBackground = UIView()
    private var searchBar = UISearchBar()
    private var searchBarText: String? = nil {
        didSet {
            updateSearchBarCancelButtonState()
            filterCategories()
        }
    }
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let minimumInteritemSpacing: CGFloat = 10.0
    private let cellsInRow = 2
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storeService.getFiltredCategories(selectedDate: selectedDate, selectedWeekDay: selectedWeekDay, searchBarText: searchBarText)
        dateFormatter.dateFormat = NSLocalizedString("trackersViewController.dateFormat", comment: "")
        configureUIElements()
    }
    
    // MARK: - Public Methods
    func filterCategories() {
        storeService.getFiltredCategories(selectedDate: selectedDate, selectedWeekDay: selectedWeekDay, searchBarText: searchBarText)
        updateTrackersCollectionView()
        updateStub()
    }
    
    func updateStub() {
        if storeService.getTrackersCount() == 0 {
            let image = UIImage(named: "stubImageForTrackers")
            stubImageView.image = image
            stubLabel.text = NSLocalizedString("trackersViewController.stub.empty", comment: "")
            stubView.isHidden = false
        } else if storeService.filteredTrackersCount == 0 {
            let image = UIImage(named: "stubImageForSearch")
            stubImageView.image = image
            stubLabel.text = NSLocalizedString("trackersViewController.stub.nothingFound", comment: "")
            stubView.isHidden = false
        } else {
            stubView.isHidden = true
        }
    }
    
    // MARK: - IBAction
    /// действие по нажатию кнопки "＋"
    @objc func plusButtonAction() {
        let newTrackerCreationVC = NewTrackerTypeChoiceVC()
        newTrackerCreationVC.delegate = self
        let newTrackerNavigation = UINavigationController(rootViewController: newTrackerCreationVC)
        present(newTrackerNavigation, animated: true)
    }
    
    /// действие при выборе новой даты
    @objc func dateChanged() {
        selectedDate = datePicker.date.short
        selectedWeekDay = Calendar.current.component(.weekday, from: datePicker.date)
        dateLabel.text = getFormattedString(from: selectedDate)
        filterCategories()
    }
    
    // MARK: - Private Methods
    /// настраиваем внешний вид экрана и графические элементы
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setPlusButton()
        setDatePicker()
        setTitleLabel()
        setSearchBarBackgrounds()
        setSearchBar()
        updateSearchBarCancelButtonState()
        setTrackersCollectionView()
        setStubImage()
        updateStub()
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
        datePicker.layer.masksToBounds = true
        datePicker.layer.cornerRadius = 8
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        self.datePicker = datePicker
        
        let dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.font = Fonts.SFPro17Regular
        dateLabel.text = getFormattedString(from: Date())
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = Colors.grayDatePicker
        dateLabel.textColor = .black
        dateLabel.isUserInteractionEnabled = true
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 8
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        datePicker.addSubview(dateLabel)
        self.dateLabel = dateLabel
        
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
        titleLabel.text = NSLocalizedString("trackersViewController.title", comment: "")
        titleLabel.font = Fonts.SFPro34Bold
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0)
        ])
    }
    
    private func setSearchBarBackgrounds() {
        let searchBarBackground = UIView()
        searchBarBackground.backgroundColor = Colors.grayDatePicker
        searchBarBackground.layer.masksToBounds = true
        searchBarBackground.layer.cornerRadius = 8
        searchBarBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarBackground)
        
        let cancelButtonLabel = UILabel()
        cancelButtonLabel.font = Fonts.SFPro17Regular
        cancelButtonLabel.textColor = .clear
        cancelButtonLabel.text = NSLocalizedString("buttons.cancel", comment: "")
        cancelButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButtonLabel)
        
        let searchBarWideBackground = UIView()
        searchBarWideBackground.backgroundColor = Colors.grayDatePicker
        searchBarWideBackground.layer.masksToBounds = true
        searchBarWideBackground.layer.cornerRadius = 8
        searchBarWideBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBarWideBackground)
        self.searchBarBackground = searchBarWideBackground
        
        NSLayoutConstraint.activate([
            searchBarBackground.heightAnchor.constraint(equalToConstant: 36),
            searchBarBackground.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchBarBackground.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBarBackground.trailingAnchor.constraint(equalTo: cancelButtonLabel.leadingAnchor, constant: -16),
            
            cancelButtonLabel.heightAnchor.constraint(equalTo: searchBarBackground.heightAnchor),
            cancelButtonLabel.topAnchor.constraint(equalTo: searchBarBackground.topAnchor),
            cancelButtonLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            searchBarWideBackground.heightAnchor.constraint(equalTo: searchBarBackground.heightAnchor),
            searchBarWideBackground.leadingAnchor.constraint(equalTo: searchBarBackground.leadingAnchor),
            searchBarWideBackground.topAnchor.constraint(equalTo: searchBarBackground.topAnchor),
            searchBarWideBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = NSLocalizedString("trackersViewController.searchBarPlaceholder", comment: "")
        searchBar.showsCancelButton = true
        searchBar.searchTextField.borderStyle = .none
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        searchBar.searchTextField.font = Fonts.SFPro17Regular
        searchBar.searchTextField.textColor = .ypBlack
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchTextField.clearButtonMode = .never
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("buttons.cancel", comment: "")
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        self.searchBar = searchBar
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setStubImage() {
        let stubView = UIView()
        stubView.backgroundColor = .none
        stubView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stubView)
        self.stubView = stubView
        
        let image = UIImage(named: "stubImageForTrackers")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubImageView)
        self.stubImageView = stubImageView
        
        stubLabel.text = ""
        stubLabel.font = Fonts.SFPro12Semibold
        stubLabel.textColor = Colors.black
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubLabel)
        
        NSLayoutConstraint.activate([
            stubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stubView.heightAnchor.constraint(equalToConstant: 110),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.bottomAnchor.constraint(equalTo: stubView.centerYAnchor),
            stubImageView.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            stubLabel.heightAnchor.constraint(equalToConstant: 18),
            stubLabel.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            stubLabel.centerXAnchor.constraint(equalTo: stubView.centerXAnchor)
        ])
    }
    
    private func setTrackersCollectionView() {
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        trackersCollectionView.register(TrackersCVCell.self, forCellWithReuseIdentifier: "cell")
        trackersCollectionView.register(TrackersCVHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        trackersCollectionView.backgroundColor = Colors.white
        trackersCollectionView.showsVerticalScrollIndicator = false
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateSearchBarCancelButtonState() {
        searchBarBackground.isHidden = searchBarText?.count ?? 0 > 0
        searchBar.setShowsCancelButton(searchBarText?.count ?? 0 > 0, animated: true)
    }
    
    private func isSameDate(trackerDate: Date) -> Bool {
        return Calendar.current.isDate(trackerDate, inSameDayAs: selectedDate)
    }
    
    private func getFormattedString(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return storeService.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeService.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackersCVCell {
            cell.delegate = self
            let tracker = storeService.object(at: indexPath)
            let isTrackerCompletedToday: Bool = {
                storeService.completedTrackers.contains {record in
                    record.id == tracker.id && isSameDate(trackerDate: record.date)
                }
            }()
            
            let count = storeService.completedTrackers.filter {record in
                record.id == tracker.id
            }.count
            
            let isEvent = tracker.schedule == nil
            
            cell.configure(for: tracker, with: indexPath, isEvent: isEvent, selectedDate: selectedDate, isCompleted: isTrackerCompletedToday, daysCount: count)
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersCVHeader {
            headerView.configure(with: storeService.getSectionName(for: indexPath.section))
            
            return headerView
        }
        fatalError("Проблема с подготовкой хедера")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow = CGFloat(self.cellsInRow)
        let cellHeight: CGFloat = 148
        return CGSize(width: (collectionView.bounds.width - (cellsInRow - 1) * minimumInteritemSpacing) / cellsInRow, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText.lowercased()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBarText = nil
        self.view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - TrackersCVCellDelegate
extension TrackersViewController: TrackersCVCellDelegate {
    
    func updateTrackerStatus(trackerID: UUID, indexPath: IndexPath, completeStatus: Bool) {
        switch completeStatus {
        case true:
            storeService.addTrackerRecordToStore(record: TrackerRecord(id: trackerID, date: selectedDate))
        case false:
            storeService.deleteRecordFromStore(record: TrackerRecord(id: trackerID, date: selectedDate))
        }
        trackersCollectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - StoreServiceDelegate
extension TrackersViewController: StoreServiceDelegate {
    func updateTrackersCollectionView() {
        trackersCollectionView.reloadData()
    }
}
