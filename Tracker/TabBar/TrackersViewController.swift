//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

final class TrackersViewController: UIViewController, TrackersVCDelegate {
    
    // MARK: - Public Properties
    lazy var storeService: StoreServiceProtocol = StoreService(trackersVCdelegate: self)
    
    // MARK: - Private Properties
    private var plusButton = UIButton()
    private var filtersButton = UIButton()
    private (set) var selectedDate = Date().short
    private (set) var selectedWeekDay: Int = Calendar.current.component(.weekday, from: Date())
    private (set) var selectedFilter: Filters = .all
    private let dateFormatter = DateFormatter()
    private var datePicker = UIDatePicker()
    private var dateLabel = UILabel()
    private var stubView = UIView()
    private var stubImageView = UIImageView()
    private var stubLabel = UILabel()
    private var titleLabel = UILabel()
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
    private var cellWidth: CGFloat = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        storeService.getFiltredCategories(
            selectedDate: selectedDate,
            selectedWeekDay: selectedWeekDay,
            searchBarText: searchBarText,
            selectedFilter: selectedFilter
        )
        dateFormatter.dateFormat = NSLocalizedString("trackersViewController.dateFormat", comment: "")
        configureUIElements()
    }
    
    // MARK: - Public Methods
    func filterCategories() {
        storeService.getFiltredCategories(
            selectedDate: selectedDate,
            selectedWeekDay: selectedWeekDay,
            searchBarText: searchBarText,
            selectedFilter: selectedFilter
        )
        updateTrackersCollectionView()
        updateStub()
        updateFilterButtonState()
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
    
    func updateTrackersCollectionView() {
        trackersCollectionView.reloadData()
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
        
        if selectedFilter == .today && selectedDate != Date().short {
            selectedFilter = .all
        }
        
        filterCategories()
    }
    
    @objc func filtersButtonAction() {
        let vc = FiltersVC(delegate: self, selectedFilter: selectedFilter)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    /// настраиваем внешний вид экрана и графические элементы
    private func configureUIElements() {
        view.backgroundColor = Colors.generalBackground
        setPlusButton()
        setDatePicker()
        setTitleLabel()
        setSearchBar()
        updateSearchBarCancelButtonState()
        setTrackersCollectionView()
        setStubImage()
        updateStub()
        setFiltersButton()
        updateFilterButtonState()
    }
    
    private func setPlusButton() {
        guard let plusButtonImage = UIImage(named: "plusButton") else {
            return
        }
        let plusButton = UIButton.systemButton(with: plusButtonImage, target: self, action: #selector(self.plusButtonAction))
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.tintColor = Colors.generalTextcolor
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
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 0)
        ])
    }
    
    private func setSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = NSLocalizedString("trackersViewController.searchBarPlaceholder", comment: "")
        searchBar.searchTextField.layer.cornerRadius = 8
        searchBar.searchTextField.backgroundColor = Colors.searchBarBG
        searchBar.searchTextField.tintColor = Colors.generalTextcolor
        searchBar.searchTextField.textColor = Colors.generalTextcolor
        searchBar.showsCancelButton = true
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchTextField.clearButtonMode = .never
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = NSLocalizedString("buttons.cancel", comment: "")
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        self.searchBar = searchBar
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8)
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
        stubLabel.textColor = Colors.generalTextcolor
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
        trackersCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        trackersCollectionView.backgroundColor = Colors.generalBackground
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
    
    private func setFiltersButton() {
        let filtersButton = UIButton()
        filtersButton.addTarget(self, action: #selector(filtersButtonAction), for: .touchUpInside)
        filtersButton.backgroundColor = Colors.blue
        filtersButton.setTitle(NSLocalizedString("filtersVC.title", comment: ""), for: .normal)
        filtersButton.titleLabel?.font = Fonts.SFPro16Medium
        filtersButton.setTitleColor(Colors.white, for: .normal)
        filtersButton.layer.masksToBounds = true
        filtersButton.layer.cornerRadius = 16
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersButton)
        self.filtersButton = filtersButton
        
        NSLayoutConstraint.activate([
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filtersButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func updateSearchBarCancelButtonState() {
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
            let isPinned = storeService.isPinned(trackerID: tracker.id)
            
            cell.configure(for: tracker,
                           with: indexPath,
                           isEvent: isEvent,
                           selectedDate: selectedDate,
                           isCompleted: isTrackerCompletedToday,
                           isPinned: isPinned,
                           daysCount: count
            )
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackersCVHeader {
                headerView.configure(with: storeService.getSectionName(for: indexPath.section))
                return headerView
            }
            
        default:
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            footer.frame = CGRect(x: 0, y: 0, width: trackersCollectionView.frame.size.width, height: 100)
            return footer
        }
        
        fatalError("Проблема с подготовкой хедера")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsInRow = CGFloat(cellsInRow)
        let cellHeight: CGFloat = 148
        cellWidth = (collectionView.bounds.width - (cellsInRow - 1) * minimumInteritemSpacing) / cellsInRow
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let height = section == storeService.numberOfSections - 1 ? 55.0 : 0.0
        
        return CGSize(width: collectionView.bounds.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let tracker: Tracker = storeService.filteredTrackers[indexPath.section].trackers[indexPath.row]
        let isPinned = storeService.isPinned(trackerID: tracker.id)
        
        return UIContextMenuConfiguration(previewProvider: { [weak self] in
            self?.getPreview(for: tracker, which: isPinned)
        },
                                          actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: isPinned
                         ? NSLocalizedString("trackersViewController.contextMenu.unpin", comment: "")
                         : NSLocalizedString("trackersViewController.contextMenu.pin", comment: "")
                        ) { [weak self] _ in
                            self?.updatePinnedStatus(for: tracker.id, with: !isPinned)
                        },
                
                UIAction(title: NSLocalizedString("trackersViewController.contextMenu.edit", comment: "")) { [weak self] _ in
                    self?.editTracker(indexPath: indexPath)
                },
                
                UIAction(title: NSLocalizedString("trackersViewController.contextMenu.delete", comment: ""), attributes: .destructive) { [weak self] _ in
                    self?.deleteTracker(indexPath: indexPath)
                },
                
            ])
        })
    }
    
    private func updatePinnedStatus(for trackerID: UUID, with newStatus: Bool) {
        newStatus ? storeService.addPinnedTrackerToStore(uuid: trackerID) : storeService.deletePinnedTrackerFromStore(uuid: trackerID)
        storeService.fetchPinnedTrackers()
        filterCategories()
    }
    
    private func editTracker(indexPath: IndexPath) {
        
        let tracker = storeService.object(at: indexPath)
        let count = storeService.completedTrackers.filter {record in
            record.id == tracker.id
        }.count
        let category = storeService.getTrackerCategory(for: tracker.id)
        
        let isEvent = tracker.schedule == nil
        
        let params = EditModeParams(tracker: tracker,
                                    category: category,
                                    daysCount: count
        )
        
        let vc = TrackerCreationVC(newTrackerType: isEvent ? .event : .habit,
                                   delegate: self,
                                   editModeParams: params
        )
        
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func deleteTracker(indexPath: IndexPath) {
        let tracker = storeService.object(at: indexPath)
        self.present(getDeleteAlertView(for: tracker.id), animated: true)
    }
    
    private func getDeleteAlertView(for trackerID: UUID) -> UIAlertController {
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("trackersViewController.contextMenu.delete.alert", comment: ""),
                                      preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("trackersViewController.contextMenu.delete", comment: ""),
                                      style: .destructive) {_ in
            self.storeService.deleteFromStore(tracker: trackerID)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("buttons.cancel", comment: ""),
                                      style: .cancel) {_ in
            alert.dismiss(animated: true)
        })
        
        return alert
    }
    
    private func getPreview(for tracker: Tracker, which isPinned: Bool) -> UIViewController {
        let previewVC = UIViewController()
        previewVC.preferredContentSize = CGSize(width: cellWidth, height: 90)
        previewVC.view.backgroundColor = UIColor(named: "Color\(tracker.color ?? 1)")
        
        let emojiBGView = UIView()
        emojiBGView.backgroundColor = Colors.whiteEmojiCircle
        emojiBGView.layer.masksToBounds = true
        emojiBGView.layer.cornerRadius = 12
        emojiBGView.translatesAutoresizingMaskIntoConstraints = false
        previewVC.view.addSubview(emojiBGView)
        
        let emojiView = UIImageView()
        emojiView.image = UIImage(named: "emoji\(tracker.emoji ?? 1)")
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        previewVC.view.addSubview(emojiView)
        
        let titleLabel = UITextView()
        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.SFPro12Semibold
        titleLabel.textColor = Colors.white
        titleLabel.text = tracker.name
        titleLabel.backgroundColor = .clear
        titleLabel.isUserInteractionEnabled = false
        titleLabel.isSelectable = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        previewVC.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            emojiBGView.heightAnchor.constraint(equalToConstant: 24),
            emojiBGView.widthAnchor.constraint(equalToConstant: 24),
            emojiBGView.topAnchor.constraint(equalTo: previewVC.view.topAnchor, constant: 12),
            emojiBGView.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor, constant: 12),
            
            emojiView.heightAnchor.constraint(equalToConstant: 16),
            emojiView.widthAnchor.constraint(equalToConstant: 16),
            emojiView.centerXAnchor.constraint(equalTo: emojiBGView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: emojiBGView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiBGView.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: previewVC.view.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor, constant: -12)
        ])
        
        if isPinned {
            let pinView = UIImageView()
            pinView.image = UIImage(named: "pin")
            pinView.translatesAutoresizingMaskIntoConstraints = false
            previewVC.view.addSubview(pinView)
            
            pinView.heightAnchor.constraint(equalToConstant: 12).isActive = true
            pinView.widthAnchor.constraint(equalToConstant: 8).isActive = true
            pinView.centerYAnchor.constraint(equalTo: emojiBGView.centerYAnchor).isActive = true
            pinView.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor, constant: -12).isActive = true
        }
        
        return previewVC
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

// MARK: - TrackersViewController
extension TrackersViewController: FiltersVCDelegate {
    
    func updateSelectedFilter(with newFilter: Filters) {
        selectedFilter = newFilter
        if newFilter == .today {
            datePicker.date = Date()
            dateChanged()
        } else {
            filterCategories()
        }
    }
    
    func updateFilterButtonState() {
        
        switch selectedFilter {
            
        case .today:
            filtersButton.backgroundColor = selectedDate == Date().short
            ? Colors.red
            : Colors.blue
        case .completed, .uncompleted:
            filtersButton.backgroundColor = Colors.red
        default:
            filtersButton.backgroundColor = Colors.blue
        }
        
        filtersButton.isHidden = storeService.getFetchedTrackersCount() == 0
    }
}
