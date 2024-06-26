//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 16.05.2024.
//
import UIKit

enum TrackerType: String {
    case habit
    case event
}

enum CellID: String {
    case title = "title"
    case category = "category"
    case shedule = "shedule"
    case spacer = "spacer"
    case emoji = "emoji"
    case color = "color"
}

enum ReuseID: String {
    case text = "mainTableCell"
    case collection = "mainTableCellWithCollection"
}

struct MainTableCellParams {
    let id: CellID
    let reuseID: ReuseID
    var cellHeight: CGFloat
    let title: String
    var value: String? = nil
}

final class NewTrackerCreationVC: UIViewController {
    
    // MARK: - Public Properties
    weak var superDelegate: TrackersViewController?
    var mainTableView = UITableView()
    var newTrackerType: TrackerType
    var newTrackerTitle: String? {
        didSet {
            self.mainTableCells[0].value = newTrackerTitle
            updateButtonState()
        }
    }
    var newTrackerCategory: String? {
        didSet {
            self.mainTableCells[2].value = newTrackerCategory
            mainTableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            updateButtonState()
        }
    }
    var newTrackerSchedule: Set<Int>?
    var newTrackerScheduleLabelText: String? {
        didSet {
            self.mainTableCells[3].value = newTrackerScheduleLabelText
            mainTableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
            updateButtonState()
        }
    }
    
    var categories: Set<String> = []
    
    // MARK: - Private Properties
    private var mainTableCells: [MainTableCellParams] = []
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var minimumTitleLength = 1
    private var maximumTitleLength = 38
    private var newTrackerEmoji: Int?
    private var newTrackerColor: Int?
    
    // MARK: - Initializers
    init(newTrackerType: TrackerType, delegate: NewTrackerTypeChoiceVC, superDelegate: TrackersViewController) {
        self.newTrackerType = newTrackerType
        self.superDelegate = superDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoriesList()
        configureCommonUIElements(for : newTrackerType)
        configureMainTable(for: newTrackerType)
    }
    
    // MARK: - IBAction
    @objc private func cancelButtonPressed() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonPressed() {
        self.superDelegate?.updateCategories(with: categories)
        let tracker = Tracker(id: UUID(),
                              name: self.newTrackerTitle ?? "б/н",
                              color: (self.newTrackerColor ?? 0) + 1,
                              emoji: (self.newTrackerEmoji ?? 0) + 1,
                              schedule: self.newTrackerSchedule
        )
        
        if let category = self.newTrackerCategory {
            self.superDelegate?.addNew(tracker: tracker, to: category)
        }
        
        if newTrackerType == .event,
           let date = superDelegate?.selectedDate {
            superDelegate?.addNew(record: TrackerRecord(id: tracker.id, date: date))
        }
        superDelegate?.filterCategories()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func switchToCategoryVC() {
        let vc = CategoryVC(delegate: self, categories: self.categories)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func switchToScheduleVC() {
        let vc = ScheduleVC(delegate: self)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    private func configureCommonUIElements(for tracker: TrackerType) {
        view.backgroundColor = Colors.white
        setTitle(for: newTrackerType)
        setButtons()
        updateButtonState()
    }
    
    private func configureMainTable(for tracker: TrackerType) {
        self.mainTableCells.append(MainTableCellParams(id: .title, reuseID: .text, cellHeight: 75, title: "Введите название трекера"))
        self.mainTableCells.append(MainTableCellParams(id: .spacer, reuseID: .text, cellHeight: 24, title: ""))
        self.mainTableCells.append(MainTableCellParams(id: .category, reuseID: .text, cellHeight: 75, title: "Категория", value: nil))
        if tracker == .habit {
            self.mainTableCells.append(MainTableCellParams(id: .shedule, reuseID: .text, cellHeight: 75, title: "Расписание", value: nil))
        }
        self.mainTableCells.append(MainTableCellParams(id: .emoji, reuseID: .collection, cellHeight: 0, title: "Emoji", value: nil))
        self.mainTableCells.append(MainTableCellParams(id: .color, reuseID: .collection, cellHeight: 0, title: "Цвет", value: nil))
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.backgroundColor = .none
        mainTableView.separatorStyle = .singleLine
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.register(NTCTableCell.self, forCellReuseIdentifier: ReuseID.text.rawValue)
        mainTableView.register(NTCTableCellwithCollection.self, forCellReuseIdentifier: ReuseID.collection.rawValue)
        mainTableView.contentInset.top = 24
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 63),
            mainTableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
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
    
    private func getCategoriesList() {
        var categories: Set<String> = []
        self.superDelegate?.categories.forEach{
            categories.insert($0.category)
        }
        self.categories = categories
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
}

// MARK: - UITableViewDataSource
extension NewTrackerCreationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainTableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mainTableCells[indexPath.row].reuseID {
        case .text:
            if let cell = tableView.dequeueReusableCell(withIdentifier: mainTableCells[indexPath.row].reuseID.rawValue, for: indexPath) as? NTCTableCell {
                cell.delegate = self
                cell.configure(new: mainTableCells[indexPath.row], for: newTrackerType)
                return cell
            }
        case .collection:
            if let cell = tableView.dequeueReusableCell(withIdentifier: mainTableCells[indexPath.row].reuseID.rawValue, for: indexPath) as? NTCTableCellwithCollection {
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
extension NewTrackerCreationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mainTableCells[indexPath.row].reuseID {
        case .text:
            return mainTableCells[indexPath.row].cellHeight
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
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mainTableCells[indexPath.row].id {
        case .shedule:
            switchToScheduleVC()
        case .category:
            switchToCategoryVC()
        default:
            return
        }
    }
}

// MARK: - NTCTableCellDelegate
extension NewTrackerCreationVC: NTCTableCellDelegate {
    
    func updateNewTrackerName(with title: String?) {
        guard let title
        else {
            return
        }
        newTrackerTitle = title
    }
}

// MARK: - NTCTableCellwithCollectionDelegate
extension NewTrackerCreationVC: NTCTableCellwithCollectionDelegate {
    
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
