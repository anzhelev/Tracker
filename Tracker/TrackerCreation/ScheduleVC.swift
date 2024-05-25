//
//  ScheduleSetVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 17.05.2024.
//
import UIKit

final class ScheduleVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: NewTrackerCreationVC?
    
    // MARK: - Private Properties
    private var titleLabel = UILabel()
    private let weekDaysTableView = UITableView()
    private var confirmButton = UIButton()
    private let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let daysOfWeekShort = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    private var schedule: Set<Int>
    
    // MARK: - Initializers
    init(delegate: NewTrackerCreationVC) {
        self.delegate = delegate
        self.schedule = delegate.newTrackerSchedule ?? []
        
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
            self.schedule.insert(getDayIndexFromRowIndex(for: sender.tag))
        case false:
            self.schedule.remove(getDayIndexFromRowIndex(for: sender.tag))
        }
        updateButtonState()
    }
    
    @objc private func confirmButtonPressed() {
        if schedule.count > 0 {
            self.delegate?.newTrackerSchedule = schedule
            
            if schedule.count == 7 {
                self.delegate?.newTrackerScheduleLabelText = "Каждый день"
            } else {
                var selectedIndexes: Set<Int> = []
                for index in 0...6 {
                    if schedule.contains(getDayIndexFromRowIndex(for: index)) {
                        selectedIndexes.insert(index)
                    }
                }
                var days: [String] = []
                selectedIndexes.sorted().forEach { index in
                    days.append(self.daysOfWeekShort[index])
                }
                self.delegate?.newTrackerScheduleLabelText = days.joined(separator: ", ")
            }
        } else {
            self.delegate?.newTrackerSchedule = nil
            self.delegate?.newTrackerScheduleLabelText = nil
        }
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Properties
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setTitle()
        setTableView()
        setButton()
        updateButtonState()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Расписание"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
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
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
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
        label.font = UIFont(name: SFPro.regular, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        let switcher = UISwitch()
        switcher.onTintColor = Colors.blue
        switcher.setOn(schedule.contains(getDayIndexFromRowIndex(for: row)), animated: true)
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
    
    private func getDayIndexFromRowIndex(for row: Int) -> Int {
        let index = row + Calendar.current.firstWeekday
        return index > 7 ? index - 7 : index
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
