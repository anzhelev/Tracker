//
//  FiltersVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 17.07.2024.
//
import UIKit

enum Filters: String {
    case all = "filtersVC.cell.all"
    case today = "filtersVC.cell.today"
    case completed = "filtersVC.cell.completed"
    case uncompleted = "filtersVC.cell.uncompleted"
}

struct FiltersTableCellParams {
    let title: String
    let corners: RoundedCorners
    let separator: Bool
    var isSelected: Bool
}

protocol FiltersVCDelegate: AnyObject {
    func updateSelectedFilter(with: Filters)
}

final class FiltersVC: UIViewController {
    
    // MARK: - Private Properties
    private weak var delegate: FiltersVCDelegate?
    private var selectedFilter = Filters.all
    private var titleLabel = UILabel()
    private let filtersTableView = UITableView()
    private let filters: [Filters] = [.all, .today, .completed, .uncompleted]
        
    // MARK: - Initializers
    init(delegate: FiltersVCDelegate, selectedFilter: Filters) {
        self.delegate = delegate
        self.selectedFilter = selectedFilter
        
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
    
    // MARK: - Private Methods

    private func configureUIElements() {
        view.backgroundColor = Colors.generalBackground
        setTitle()
        setTableView()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("filtersVC.title", comment: "")
        titleLabel.font = Fonts.sfPro16Medium
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
  
    private func setTableView() {
        filtersTableView.register(FiltersTableCell.self, forCellReuseIdentifier: "cell")
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        filtersTableView.backgroundColor = Colors.generalBackground
        filtersTableView.showsVerticalScrollIndicator = false
        filtersTableView.separatorColor = Colors.grayCellsSeparator
        filtersTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        filtersTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersTableView)
        
        NSLayoutConstraint.activate([
            filtersTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            filtersTableView.heightAnchor.constraint(equalToConstant: 600),
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func getCellParams(for row: Int) -> FiltersTableCellParams {
        var corners: RoundedCorners = .none
        var separator: Bool = true
        
        switch row {
        case 0:
            corners = .top
        case 3:
            corners = .bottom
            separator = false
        default:
            break
        }

        return FiltersTableCellParams(
            title: NSLocalizedString(filters[row].rawValue, comment: "") ,
            corners: corners,
            separator: separator,
            isSelected: filters[row] == selectedFilter)
    }
    
    private func updateTableView() {
        filtersTableView.reloadData()
    }
    
    private func dismissVC() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension FiltersVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FiltersTableCell {
            
            cell.configure(with: getCellParams(for: indexPath.row))
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

// MARK: - UITableViewDelegate
extension FiltersVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateSelectedFilter(with: filters[indexPath.row])
        dismissVC()
    }
}
