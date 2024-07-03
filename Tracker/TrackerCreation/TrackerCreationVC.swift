//
//  TrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.05.2024.
//
import UIKit

enum TrackerType: String {
    case habit
    case event
}

enum CellID: String {
    case title = "title"
    case warning = "warning"
    case spacer = "spacer"
    case category = "category"
    case schedule = "shedule"
    case emoji = "emoji"
    case color = "color"
}

enum ReuseID: String {
    case textInput = "textInput"
    case singleLabel = "singleLabel"
    case doubleLabel = "doubleLabel"
    case spacer = "spacer"
    case collection = "collection"
}

enum RoundedCorners: String {
    case top
    case bottom
    case all
    case none
}

struct CellParams {
    let id: CellID
    let reuseID: ReuseID
    var cellHeight: CGFloat
    let rounded: RoundedCorners
    let separator: Bool
    let title: String
    var value: String? = nil
}

final class TrackerCreationVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: TrackersViewController?
    
    var newTrackerType: TrackerType
    var newTrackerTitle: String? {
        didSet {
            self.mainTableCells[0].value = newTrackerTitle
            updateButtonState()
        }
    }
    var newTrackerCategory: String? {
        didSet {
            self.mainTableCells[3].value = newTrackerCategory
            mainTable.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            updateButtonState()
        }
    }
    var newTrackerSchedule: Set<Int>?
    var newTrackerScheduleLabelText: String? {
        didSet {
            self.mainTableCells[4].value = newTrackerScheduleLabelText
            mainTable.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
            updateButtonState()
        }
    }
    
    var categories: Set<String> = []
    
    // MARK: - Private Properties
    private var mainTable = UITableView()
    private var mainTableCells: [CellParams] = []
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var minimumTitleLength = 1
    private var maximumTitleLength = 38
    private var newTrackerEmoji: Int?
    private var newTrackerColor: Int?
    private var warningIsShown: Bool = false
    
    // MARK: - Initializers
    init(newTrackerType: TrackerType, delegate: TrackersViewController) {
        self.newTrackerType = newTrackerType
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.white
        
        getCategoriesList()
        setTitle(for: newTrackerType)
        setButtons()
        updateButtonState()
        configureMainTable(for: newTrackerType)
    }
    
    // MARK: - IBAction
    @objc private func cancelButtonPressed() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonPressed() {
        self.delegate?.storeService.addCategoriesToStore(newlist: categories)
        let tracker = Tracker(id: UUID(),
                              name: self.newTrackerTitle ?? "б/н",
                              color: (self.newTrackerColor ?? 0) + 1,
                              emoji: (self.newTrackerEmoji ?? 0) + 1,
                              schedule: self.newTrackerSchedule
        )
        
        if let category = self.newTrackerCategory {
            let date = delegate?.selectedDate.short ?? Date().short
            if newTrackerType == .event {
                self.delegate?.storeService.addTrackerRecordToStore(record: TrackerRecord(id: tracker.id, date: date))
            }
            self.delegate?.storeService.addTrackerToStore(tracker: tracker,
                                                          eventDate: newTrackerType == .event ? date : nil ,
                                                          to: category
            )
        }
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func switchToCategoryVC() {
        let vc = CategoryVC(delegate: self, categories: self.categories, newTrackerCategory: self.newTrackerCategory)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func switchToScheduleVC() {
        let vc = ScheduleVC(delegate: self, newTrackerSchedule: newTrackerSchedule)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    private func getCategoriesList() {
        self.categories = delegate?.storeService.categoryList ?? []
    }
    
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = Fonts.SFPro16Semibold
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func setButtons() {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.white
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = Fonts.SFPro16Semibold
        cancelButton.setTitleColor(Colors.red, for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Colors.red.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        createButton.backgroundColor = Colors.grayDisabledButton
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = Fonts.SFPro16Semibold
        createButton.setTitleColor(Colors.white, for: .normal)
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        createButton.isEnabled = false
        self.createButton = createButton
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func updateButtonState() {
        let count = self.newTrackerTitle?.count ?? 0
        if count >= minimumTitleLength,
           count <= maximumTitleLength,
           self.newTrackerCategory != nil,
           self.newTrackerSchedule != nil || self.newTrackerType == .event,
           self.newTrackerColor != nil,
           self.newTrackerEmoji != nil {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
        createButton.backgroundColor = createButton.isEnabled ? Colors.black : Colors.grayDisabledButton
    }
    
    
    private func configureMainTable(for tracker: TrackerType) {
        self.mainTableCells.append(CellParams(id: .title, reuseID: .textInput, cellHeight: 75, rounded: .all, separator: false, title: "Введите название трекера"))
        self.mainTableCells.append(CellParams(id: .warning, reuseID: .singleLabel, cellHeight: 0, rounded: .none, separator: false, title: "Ограничение 38 символов"))
        self.mainTableCells.append(CellParams(id: .spacer, reuseID: .spacer, cellHeight: 24, rounded: .none, separator: false, title: ""))
        if tracker == .habit {
            self.mainTableCells.append(CellParams(id: .category, reuseID: .doubleLabel, cellHeight: 75, rounded: .top, separator: true, title: "Категория"))
            self.mainTableCells.append(CellParams(id: .schedule, reuseID: .doubleLabel, cellHeight: 75, rounded: .bottom, separator: false, title: "Расписание"))
        } else {
            self.mainTableCells.append(CellParams(id: .category, reuseID: .doubleLabel, cellHeight: 75, rounded: .all, separator: false, title: "Категория"))
        }
        self.mainTableCells.append(CellParams(id: .emoji, reuseID: .collection, cellHeight: 0, rounded: .none, separator: false, title: "Emoji"))
        self.mainTableCells.append(CellParams(id: .color, reuseID: .collection, cellHeight: 0, rounded: .none, separator: false, title: "Цвет"))
        
        mainTable.register(TCTableCellTextInput.self, forCellReuseIdentifier: ReuseID.textInput.rawValue)
        mainTable.register(TCTableCellSingleLabel.self, forCellReuseIdentifier: ReuseID.singleLabel.rawValue)
        mainTable.register(TCTableCellSpacer.self, forCellReuseIdentifier: ReuseID.spacer.rawValue)
        mainTable.register(TCTableCellDoubleLabel.self, forCellReuseIdentifier: ReuseID.doubleLabel.rawValue)
        mainTable.register(TCTableCellCollection.self, forCellReuseIdentifier: ReuseID.collection.rawValue)
        
        mainTable.dataSource = self
        mainTable.delegate = self
        
        mainTable.backgroundColor = .none
        mainTable.separatorStyle = .singleLine
        mainTable.showsVerticalScrollIndicator = false
        mainTable.contentInset.top = 24
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainTable)
        
        NSLayoutConstraint.activate([
            mainTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            mainTable.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            mainTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource
extension TrackerCreationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainTableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseID = mainTableCells[indexPath.row].reuseID
        switch reuseID {
            
        case .textInput:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID.rawValue, for: indexPath) as? TCTableCellTextInput {
                cell.delegate = self
                cell.configure(new: mainTableCells[indexPath.row])
                return cell
            }
        case .singleLabel:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID.rawValue, for: indexPath) as? TCTableCellSingleLabel {
                cell.configure(new: mainTableCells[indexPath.row], warningIsShown: warningIsShown)
                return cell
            }
        case .doubleLabel:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID.rawValue, for: indexPath) as? TCTableCellDoubleLabel {
                cell.configure(new: mainTableCells[indexPath.row])
                return cell
            }
        case .spacer:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID.rawValue, for: indexPath) as? TCTableCellSpacer {
                cell.configure(new: mainTableCells[indexPath.row])
                return cell
            }        case .collection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: reuseID.rawValue, for: indexPath) as? TCTableCellCollection {
                cell.delegate = self
                let selectedItem = mainTableCells[indexPath.row].id == .emoji ? newTrackerEmoji : newTrackerColor
                cell.configure(new: mainTableCells[indexPath.row], with: selectedItem)
                return cell
            }
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

// MARK: - UITableViewDelegate
extension TrackerCreationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mainTableCells[indexPath.row].reuseID {
            
        case .collection:
            let horizontalInset = 2.0
            let collectionHeaderHeight = 74.0
            let verticalSpacing = 0.0
            let horizontalSpacing = 5.0
            let cellsInRow = CGFloat(6)
            let rowCount = CGFloat(3)
            let collectionCellWidth = (tableView.bounds.width - horizontalInset * 2 - (cellsInRow - 1) * horizontalSpacing) / cellsInRow
            mainTableCells[indexPath.row].cellHeight = collectionCellWidth
            return collectionCellWidth * rowCount + verticalSpacing * (rowCount - 1) + collectionHeaderHeight
            
        default:
            return mainTableCells[indexPath.row].cellHeight
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mainTableCells[indexPath.row].id {
        case .schedule:
            switchToScheduleVC()
        case .category:
            switchToCategoryVC()
        default:
            return
        }
    }
}

// MARK: - TCTableCellTextInputDelegate
extension TrackerCreationVC: TCTableCellTextInputDelegate {
    
    func updateNewTrackerName(with title: String?) {
        guard let title
        else {
            return
        }
        newTrackerTitle = title
        if title.count > 38 {
            if warningIsShown == false {
                warningIsShown.toggle()
                self.mainTableCells[1].cellHeight = 38
                mainTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        } else if warningIsShown {
            warningIsShown.toggle()
            self.mainTableCells[1].cellHeight = 0
            mainTable.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
    }
}

// MARK: - CategoryVCDelegate
extension TrackerCreationVC: CategoryVCDelegate {
    func updateNewTrackerCategory(newTrackerCategory: String?, categories: Set<String>) {
        self.newTrackerCategory = newTrackerCategory
        self.categories = categories
    }
}

// MARK: - ScheduleVCDelegate
extension TrackerCreationVC: ScheduleVCDelegate {
    func updateNewTrackerSchedule(newTrackerSchedule: Set<Int>?, newTrackerScheduleLabelText: String?) {
        self.newTrackerSchedule = newTrackerSchedule
        self.newTrackerScheduleLabelText = newTrackerScheduleLabelText
    }
}

// MARK: - NTCTableCellwithCollectionDelegate
extension TrackerCreationVC: TCTableCellCollectionDelegate {
    
    func updateNewTracker(dataType: CellID, value: Int?) {
        
        switch dataType {
            
        case .emoji:
            newTrackerEmoji = value
        case .color:
            newTrackerColor = value
        default:
            return
        }
        updateButtonState()
    }
}
