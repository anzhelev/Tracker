//
//  TrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.05.2024.
//
import UIKit

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
    
    // MARK: - Private Properties
    private var editMode = false
    private var mainTable = UITableView()
    private var mainTableCells: [CellParams] = []
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var minimumTitleLength = 1
    private var maximumTitleLength = 38
    private var editedTrackerID: UUID?
    private var editedTrackerDaysCount = 0
    private var newTrackerEmoji: Int?
    private var newTrackerColor: Int?
    private var warningIsShown: Bool = false
    private let dateFormatter = DateFormatter()
    
    // MARK: - Initializers
    init(newTrackerType: TrackerType, delegate: TrackersViewController, editModeParams: EditModeParams? = nil) {
        self.newTrackerType = newTrackerType
        self.delegate = delegate
        
        if let editModeParams {
            self.editMode = true
            self.editedTrackerID = editModeParams.tracker.id
            self.newTrackerTitle = editModeParams.tracker.name
            self.newTrackerCategory = editModeParams.category
            self.editedTrackerDaysCount = editModeParams.daysCount
            self.newTrackerSchedule = editModeParams.tracker.schedule
            self.newTrackerEmoji = (editModeParams.tracker.emoji ?? 1) - 1
            self.newTrackerColor = (editModeParams.tracker.color ?? 1) - 1
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.generalBackground
        
        setTitle(for: newTrackerType)
        if editMode {
            setDaysCountLabel()
        }
        
        setButtons()
        updateButtonState()
        configureMainTable(for: newTrackerType)
    }
    
    // MARK: - IBAction
    @objc private func cancelButtonPressed() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonPressed() {
        let tracker = Tracker(id: self.editedTrackerID ?? UUID(),
                              name: self.newTrackerTitle ?? "б/н",
                              color: (self.newTrackerColor ?? 0) + 1,
                              emoji: (self.newTrackerEmoji ?? 0) + 1,
                              schedule: self.newTrackerSchedule
        )
        
        guard let newTrackerCategory else {
            return
        }
        
        let date = delegate?.selectedDate.short ?? Date().short
        
        if !editMode {
            if newTrackerType == .event {
                self.delegate?.storeService.addTrackerRecordToStore(record: TrackerRecord(id: tracker.id, date: date))
            }
            self.delegate?.storeService.addTrackerToStore(
                tracker: tracker,
                eventDate: newTrackerType == .event ? date : nil ,
                to: newTrackerCategory
            )
            
        } else {
            delegate?.storeService.updateTracker(tracker: tracker,
                                                 eventDate: newTrackerType == .event ? date : nil,
                                                 newCategory: newTrackerCategory
            )
        }
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func switchToCategoryVC() {
        let vc = CategoryVC(delegate: self, newTrackerCategory: self.newTrackerCategory)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func switchToScheduleVC() {
        let vc = ScheduleVC(delegate: self, newTrackerSchedule: newTrackerSchedule)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        if !editMode {
            titleLabel.text = tracker == .habit
            ? NSLocalizedString("trackerCreationVC.habit.title", comment: "")
            : NSLocalizedString("trackerCreationVC.event.title", comment: "")
        } else {
            titleLabel.text = tracker == .habit
            ? NSLocalizedString("trackerCreationVC.habitEditing.title", comment: "")
            : NSLocalizedString("trackerCreationVC.eventEditing.title", comment: "")
        }
        titleLabel.font = Fonts.sfPro16Medium
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func setDaysCountLabel() {
        let daysCountLabel = UILabel()
        
        daysCountLabel.text = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: ""),
            editedTrackerDaysCount
        )
        daysCountLabel.font = Fonts.sfPro32Bold
        daysCountLabel.textColor = Colors.generalTextcolor
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(daysCountLabel)
        
        NSLayoutConstraint.activate([
            daysCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            daysCountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 87)
        ])
    }
    
    private func setButtons() {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.backgroundColor = Colors.generalBackground
        cancelButton.setTitle(NSLocalizedString("buttons.cancel", comment: ""), for: .normal)
        cancelButton.titleLabel?.font = Fonts.sfPro16Medium
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
        createButton.setTitle(editMode
                              ? NSLocalizedString("buttons.save", comment: "")
                              : NSLocalizedString("buttons.create", comment: ""),
                              for: .normal
        )
        createButton.titleLabel?.font = Fonts.sfPro16Medium
        createButton.setTitleColor(Colors.generalBackground, for: .normal)
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
        
        createButton.backgroundColor = createButton.isEnabled ? Colors.generalTextcolor : Colors.grayDisabledButton
        createButton.setTitleColor(createButton.isEnabled
                                   ? Colors.generalBackground
                                   : Colors.white,
                                   for: .normal
        )
    }
    
    
    private func configureMainTable(for tracker: TrackerType) {
        
        self.mainTableCells.append(
            .init(id: .title,
                  reuseID: .textInput,
                  cellHeight: 75,
                  rounded: .all,
                  separator: false,
                  title: NSLocalizedString(CellID.title.rawValue, comment: ""),
                  value: editMode ?
                  newTrackerTitle : nil
                 )
        )
        
        self.mainTableCells.append(
            .init(id: .warning,
                  reuseID: .singleLabel,
                  cellHeight: 0,
                  rounded: .none,
                  separator: false,
                  title: NSLocalizedString(CellID.warning.rawValue, comment: "")
                 )
        )
        
        self.mainTableCells.append(
            .init(id: .spacer,
                  reuseID: .spacer,
                  cellHeight: 24,
                  rounded: .none,
                  separator: false,
                  title: ""
                 )
        )
        
        if tracker == .habit {
            self.mainTableCells.append(
                .init(id: .category,
                      reuseID: .doubleLabel,
                      cellHeight: 75,
                      rounded: .top,
                      separator: true,
                      title: NSLocalizedString(CellID.category.rawValue, comment: ""),
                      value: editMode ?
                      newTrackerCategory : nil
                     )
            )
            
            self.mainTableCells.append(
                .init(id: .schedule,
                      reuseID: .doubleLabel,
                      cellHeight: 75,
                      rounded: .bottom,
                      separator: false,
                      title: NSLocalizedString(CellID.schedule.rawValue, comment: ""),
                      value: editMode ?
                      getTrackerScheduleLabelText() : nil
                     )
            )
            
        } else {
            
            self.mainTableCells.append(
                .init(id: .category,
                      reuseID: .doubleLabel,
                      cellHeight: 75,
                      rounded: .all,
                      separator: false,
                      title: NSLocalizedString(CellID.category.rawValue, comment: ""),
                      value: editMode ?
                      newTrackerCategory : nil
                     )
            )
        }
        
        self.mainTableCells.append(
            .init(id: .emoji,
                  reuseID: .collection,
                  cellHeight: 0,
                  rounded: .none,
                  separator: false,
                  title: NSLocalizedString(CellID.emoji.rawValue, comment: "")
                 )
        )
        
        self.mainTableCells.append(
            .init(id: .color,
                  reuseID: .collection,
                  cellHeight: 0,
                  rounded: .none,
                  separator: false,
                  title: NSLocalizedString(CellID.color.rawValue, comment: "")
                 )
        )
        
        mainTable.register(TCTableCellTextInput.self, forCellReuseIdentifier: ReuseID.textInput.rawValue)
        mainTable.register(TCTableCellSingleLabel.self, forCellReuseIdentifier: ReuseID.singleLabel.rawValue)
        mainTable.register(TCTableCellSpacer.self, forCellReuseIdentifier: ReuseID.spacer.rawValue)
        mainTable.register(TCTableCellDoubleLabel.self, forCellReuseIdentifier: ReuseID.doubleLabel.rawValue)
        mainTable.register(TCTableCellCollection.self, forCellReuseIdentifier: ReuseID.collection.rawValue)
        
        mainTable.dataSource = self
        mainTable.delegate = self
        
        mainTable.backgroundColor = .none
        mainTable.separatorStyle = .singleLine
        mainTable.separatorColor = Colors.grayCellsSeparator
        mainTable.showsVerticalScrollIndicator = false
        mainTable.contentInset.top = 24
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainTable)
        
        NSLayoutConstraint.activate([
            mainTable.topAnchor.constraint(equalTo: view.topAnchor, constant: editMode ? 140 : 63),
            mainTable.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            mainTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func getTrackerScheduleLabelText() -> String? {
        
        if newTrackerSchedule?.count == 7 {
            return NSLocalizedString("trackerCreationVC.habit.schedule.everyDay", comment: "")
        }
        
        guard let shortDays = dateFormatter.shortWeekdaySymbols else {
            return nil
        }
        
        var firstDay = dateFormatter.calendar.firstWeekday
        var daysOrder: [Int] = []
        var days: [String] = []
        
        for _ in 0...6 {
            daysOrder.append(firstDay)
            if firstDay == 7 {
                firstDay = 1
            } else {
                firstDay += 1
            }
        }
        
        if let newTrackerSchedule {
            daysOrder.forEach{
                if newTrackerSchedule.sorted().contains($0) {
                    days.append(shortDays[$0 - 1])
                }
            }
        }
        
        return days.joined(separator: ", ")
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
        
        debugPrint("@@@ TrackerCreationVC: Ошибка подготовки ячейки для таблицы создания трекера.")
        return UITableViewCell()
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
extension TrackerCreationVC: CategoryViewModelDelegate {
    func updateNewTrackerCategory(newTrackerCategory: String?) {
        self.newTrackerCategory = newTrackerCategory
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
