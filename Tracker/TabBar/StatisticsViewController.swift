//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Andrey Zhelev on 04.05.2024.
//
import UIKit

struct StatisticsCells {
    var value: Int
    var description: String
}

final class StatisticsViewController: UIViewController {
    
    // MARK: - Private Properties
    private var statistics: [StatisticsCells] {
        var statistics: [StatisticsCells] = []
        for cell in 0...3 {
            statistics.append(
                StatisticsCells(value: 1,
                                description: NSLocalizedString("statisticsViewController.cell\(cell)", comment: "")
                               )
            )
        }
        return statistics
    }
    
    private var mainTable = UITableView()
    private var stubView = UIView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setTitleLabel()
        self.statistics[2].value == 0
        ? setStubImage()
        : setTableView()
    }
    
    private func setTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("statisticsViewController.title", comment: "")
        titleLabel.font = Fonts.SFPro34Bold
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44)
        ])
    }
    
    private func setStubImage() {
        let stubView = UIView()
        stubView.backgroundColor = .none
        stubView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stubView)
        self.stubView = stubView
        
        let image = UIImage(named: "stubImageForStatistics")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubImageView)
        
        let stubLabel = UILabel()
        stubLabel.text = NSLocalizedString("statisticsViewController.stub", comment: "")
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
 
    private func setTableView() {
        mainTable.register(StatisticsTableCell.self, forCellReuseIdentifier: "cell")
        mainTable.delegate = self
        mainTable.dataSource = self
        mainTable.backgroundColor = Colors.white
        mainTable.showsVerticalScrollIndicator = false
        mainTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainTable)
        
        NSLayoutConstraint.activate([
            mainTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 162),
            mainTable.heightAnchor.constraint(equalToConstant: 600),
            mainTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StatisticsTableCell {
            
            cell.configure(with: String(statistics[indexPath.row].value), description: statistics[indexPath.row].description)
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
}
