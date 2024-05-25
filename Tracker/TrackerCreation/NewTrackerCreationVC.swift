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
}

struct MainTableCellParams {
    let id: CellID
    let cellHeight: CGFloat
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
            updateTableView()
            updateButtonState()
        }
    }
    var newTrackerSchedule: Set<Int>?
    var newTrackerScheduleLabelText: String? {
        didSet {
            self.mainTableCells[3].value = newTrackerScheduleLabelText
            updateTableView()
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
                              color: .ypBlue,
                              emoji: "😎",
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
        self.mainTableCells.append(MainTableCellParams(id: .title, cellHeight: 75, title: "Введите название трекера"))
        self.mainTableCells.append(MainTableCellParams(id: .spacer, cellHeight: 24, title: ""))
        self.mainTableCells.append(MainTableCellParams(id: .category, cellHeight: 75, title: "Категория", value: nil))
        if tracker == .habit {
            self.mainTableCells.append(MainTableCellParams(id: .shedule, cellHeight: 75, title: "Расписание", value: nil))
        }
        mainTableView.dataSource = self
        mainTableView.delegate = self
        mainTableView.backgroundColor = .none
        mainTableView.separatorStyle = .singleLine
        mainTableView.register(NTCTableCell.self, forCellReuseIdentifier: "mainTableCell")
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainTableView)
        
        NSLayoutConstraint.activate([
            mainTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            mainTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
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
        cancelButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
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
        createButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
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
           self.newTrackerSchedule != nil || self.newTrackerType == .event {
            createButton.isEnabled = true
        } else {
            createButton.isEnabled = false
        }
        createButton.backgroundColor = createButton.isEnabled ? Colors.black : Colors.grayDisabledButton
    }
    
    private func updateTableView() {
        mainTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension NewTrackerCreationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainTableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mainTableCell", for: indexPath) as? NTCTableCell {
            cell.delegate = self
            cell.configure(new: mainTableCells[indexPath.row], for: newTrackerType)
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

// MARK: - UITableViewDelegate
extension NewTrackerCreationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainTableCells[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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
