//
//  ScheduleSetVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 17.05.2024.
//
import UIKit

protocol ScheduleVCDelegate: AnyObject {
    func updateNewTrackerSchedule(newTrackerSchedule: Set<Int>?, newTrackerScheduleLabelText: String?)
}

final class ScheduleVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: ScheduleVCDelegate?
    
    // MARK: - Private Properties
    private var titleLabel = UILabel()
    private let weekDaysTableView = UITableView()
    private var confirmButton = UIButton()
    private var daysOfWeek: [String] = []
    private var daysOfWeekShort: [String] = []
    private var daysOrder: [Int] = []
    private var schedule: Set<Int>
    
    // MARK: - Initializers
    init(delegate: TrackerCreationVC, newTrackerSchedule: Set<Int>?) {
        self.delegate = delegate
        self.schedule = newTrackerSchedule ?? []
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    // MARK: - IBAction
    @objc private func switcherChanged(_ sender: UISwitch) {
        switch sender.isOn {
        case true:
            self.schedule.insert(daysOrder[sender.tag])
        case false:
            self.schedule.remove(daysOrder[sender.tag])
        }
        updateButtonState()
    }
    
    @objc private func confirmButtonPressed() {
        var newSchedule: Set<Int>? = nil
        var newScheduleLabelText: String? = nil
        if schedule.count > 0 {
            newSchedule = schedule
            if schedule.count == 7 {
                newScheduleLabelText = NSLocalizedString("trackerCreationVC.habit.schedule.everyDay", comment: "")
            } else {
                var selectedIndexes: Set<Int> = []
                for index in 0...6 {
                    if schedule.contains(daysOrder[index]) {
                        selectedIndexes.insert(index)
                    }
                }
                var days: [String] = []
                selectedIndexes.sorted().forEach { index in
                    days.append(self.daysOfWeekShort[index])
                }
                newScheduleLabelText = days.joined(separator: ", ")
            }
        }
        
        delegate?.updateNewTrackerSchedule(newTrackerSchedule: newSchedule, newTrackerScheduleLabelText: newScheduleLabelText)
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Properties
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setWeekdaySymbols()
        setTitle()
        setTableView()
        setButton()
        updateButtonState()
    }
    
    private func setWeekdaySymbols() {
        let fmt = DateFormatter()
        guard let days = fmt.weekdaySymbols,
              let shortDays = fmt.shortWeekdaySymbols else {
            return
        }
        
        var firstDay = fmt.calendar.firstWeekday
        self.daysOrder = []
        
        for _ in 0...6 {
            daysOrder.append(firstDay)
            if firstDay == 7 {
                firstDay = 1
            } else {
                firstDay += 1
            }
        }
        
        for day in 0...6 {
            daysOfWeek.append(days[daysOrder[day]-1].capitalized)
            daysOfWeekShort.append(shortDays[daysOrder[day]-1].capitalized)
        }
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("trackerCreationVC.habit.schedule", comment: "")
        titleLabel.font = Fonts.SFPro16Medium
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func setTableView() {
        weekDaysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        weekDaysTableView.delegate = self
        weekDaysTableView.dataSource = self
        weekDaysTableView.backgroundColor = Colors.white
        weekDaysTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        weekDaysTableView.isScrollEnabled = false
        weekDaysTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weekDaysTableView)
        
        NSLayoutConstraint.activate([
            weekDaysTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            weekDaysTableView.heightAnchor.constraint(equalToConstant: 600),
            weekDaysTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekDaysTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setButton() {
        let confirmButton = UIButton()
        confirmButton.addTarget(self, action: #selector(confirmButtonPressed), for: .touchUpInside)
        confirmButton.backgroundColor = Colors.grayDisabledButton
        confirmButton.setTitle(NSLocalizedString("buttons.done", comment: ""), for: .normal)
        confirmButton.titleLabel?.font = Fonts.SFPro16Medium
        confirmButton.setTitleColor(Colors.white, for: .normal)
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 16
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmButton)
        confirmButton.isEnabled = false
        self.confirmButton = confirmButton
        
        NSLayoutConstraint.activate([
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func configure(new cell: UITableViewCell, for row: Int) {
        cell.backgroundColor = Colors.grayCellBackground
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        if row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 16
        } else if row == 6 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.midX, bottom: 0, right: cell.bounds.midX)
        }
        
        let label = UILabel()
        label.text = daysOfWeek[row]
        label.textColor = Colors.black
        label.font = Fonts.SFPro17Regular
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        let switcher = UISwitch()
        switcher.onTintColor = Colors.blue
        switcher.setOn(schedule.contains(daysOrder[row]), animated: true)
        switcher.tag = row
        switcher.addTarget(self, action: #selector(switcherChanged(_:)), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(switcher)
        
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        switcher.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        switcher.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -16).isActive = true
    }
    
    private func updateButtonState() {
        confirmButton.isEnabled = !schedule.isEmpty
        confirmButton.backgroundColor = confirmButton.isEnabled ? Colors.black : Colors.grayDisabledButton
    }
}

// MARK: - UITableViewDataSource
extension ScheduleVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configure(new: cell, for: indexPath.row)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ScheduleVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
