//
//  CategorySetVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 17.05.2024.
//
import UIKit

final class CategoryVC: UIViewController {
    
    weak var delegate: NewTrackerCreationVC?
    var categories: Set<String> = [] {
        didSet {
            updateTableView()
            updateStub()
        }
    }
    
    private var titleLabel = UILabel()
    private var stubView = UIView()
    private var selectedCategory: String?
    private let categoriesTableView = UITableView()
    private var categoryCreationButton = UIButton()
    
    init(delegate: NewTrackerCreationVC, categories: Set<String>) {
        self.delegate = delegate
        selectedCategory = delegate.newTrackerCategory
        self.categories = categories
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
    }
    
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setTitle()        
        setStubImage()
        setTableView()
        updateStub()
        setButton()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Категория"
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
    
    private func setStubImage() {
        let stubView = UIView()
        stubView.backgroundColor = .none
        stubView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stubView)
        self.stubView = stubView
        
        let image = UIImage(named: "tabTrackersImage")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubImageView)
        
        let label1 = UILabel()
        label1.text = "Привычки и события можно"
        label1.font = UIFont(name: SFPro.regular, size: 12)
        label1.textColor = Colors.black
        label1.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = "объединить по смыслу"
        label2.font = UIFont(name: SFPro.regular, size: 12)
        label2.textColor = Colors.black
        label2.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(label2)
        
        NSLayoutConstraint.activate([
            stubView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stubView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stubView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stubView.heightAnchor.constraint(equalToConstant: 300),
            stubImageView.heightAnchor.constraint(equalToConstant: 80),
            stubImageView.widthAnchor.constraint(equalToConstant: 80),
            stubImageView.bottomAnchor.constraint(equalTo: stubView.centerYAnchor),
            stubImageView.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            label1.heightAnchor.constraint(equalToConstant: 18),
            label1.topAnchor.constraint(equalTo: stubImageView.bottomAnchor, constant: 8),
            label1.centerXAnchor.constraint(equalTo: stubView.centerXAnchor),
            label2.heightAnchor.constraint(equalTo: label1.heightAnchor),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            label2.centerXAnchor.constraint(equalTo: stubView.centerXAnchor)
        ])
    }
    
    private func updateStub() {
        self.stubView.isHidden = !self.categories.isEmpty
        self.categoriesTableView.isHidden = self.categories.isEmpty
    }
    
    private func setTableView() {
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.backgroundColor = Colors.white
        categoriesTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoriesTableView)
        
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            categoriesTableView.heightAnchor.constraint(equalToConstant: 600),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configure(new cell: UITableViewCell, for row: Int) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = Colors.grayCellBackground
        cell.layer.masksToBounds = true
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 16
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        if self.categories.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.midX, bottom: 0, right: cell.bounds.midX)
        } else if row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if row == self.categories.count - 1 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.midX, bottom: 0, right: cell.bounds.midX)
        } else {
            cell.layer.maskedCorners = []
        }
        
        let label = UILabel()
        label.text = categories.sorted()[row]
        label.textColor = Colors.black
        label.font = UIFont(name: SFPro.regular, size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        
        let image = UIImage(named: "checksign")
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.tintColor = Colors.blue
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(checkMarkImageView)
        
        if label.text != self.selectedCategory {
            checkMarkImageView.isHidden = true
        }
        
        label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        checkMarkImageView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        checkMarkImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -21).isActive = true
    }
    
    private func setButton() {
        let categoryCreationButton = UIButton()
        categoryCreationButton.addTarget(self, action: #selector(categoryCreationButtonPressed), for: .touchUpInside)
        categoryCreationButton.backgroundColor = Colors.black
        categoryCreationButton.setTitle("Добавить категорию", for: .normal)
        categoryCreationButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        categoryCreationButton.setTitleColor(Colors.white, for: .normal)
        categoryCreationButton.layer.masksToBounds = true
        categoryCreationButton.layer.cornerRadius = 16
        categoryCreationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryCreationButton)
        self.categoryCreationButton = categoryCreationButton
        
        NSLayoutConstraint.activate([
            categoryCreationButton.heightAnchor.constraint(equalToConstant: 60),
            categoryCreationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            categoryCreationButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            categoryCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func categoryCreationButtonPressed() {
        let vc = CategoryCreationVC(delegate: self)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func updateTableView() {
        categoriesTableView.reloadData()
    }
}

extension CategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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
        let cell = categoriesTableView.cellForRow(at: indexPath)
        cell?.contentView.subviews.last?.isHidden = false
        self.delegate?.newTrackerCategory = categories.sorted()[indexPath.row]
        self.delegate?.categories = categories
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = categoriesTableView.cellForRow(at: indexPath)
        cell?.contentView.subviews.last?.isHidden = true
    }
}

extension CategoryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configure(new: cell, for: indexPath.row)
        return cell
    }
}
