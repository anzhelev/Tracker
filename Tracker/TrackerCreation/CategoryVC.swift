//
//  CategoryVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 10.07.2024.
//
import UIKit

struct CategoryTableCellParams {
    let title: String
    let corners: RoundedCorners
    let separator: Bool
    var isSelected: Bool
}

final class CategoryVC: UIViewController {
    
    // MARK: - Private Properties
    private var viewModel: CategoryViewModel
    private var titleLabel = UILabel()
    private var stubView = UIView()
    private let categoriesTableView = UITableView()
    private var categoryCreationButton = UIButton()
    
    
    // MARK: - Initializers
    init(delegate: TrackerCreationVC, newTrackerCategory: String?) {
        self.viewModel = CategoryViewModel(delegate: delegate, selectedCategory: newTrackerCategory)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIElements()
        bind()
    }
    
    // MARK: - IBAction
    @objc private func categoryCreationButtonPressed() {
        let vc = CategoryCreationVC(delegate: viewModel, editMode: false, categoryName: nil)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    private func categoryEditButtonPressed(categoryName: String) {
        let vc = CategoryCreationVC(delegate: viewModel, editMode: true, categoryName: categoryName)
        let newTrackerNavigation = UINavigationController(rootViewController: vc)
        present(newTrackerNavigation, animated: true)
    }
    
    // MARK: - Private Methods
    private func bind() {
        viewModel.categoryListDidUpdate = {[weak self] _ in
            self?.updateStub()
            self?.updateTableView()
        }
        
        viewModel.selectedCategoryDidUpdate = {[weak self] _ in
            self?.dismissVC()
        }
    }
    
    private func configureUIElements() {
        view.backgroundColor = Colors.generalBackground
        setTitle()
        setTableView()
        setStubImage()
        updateStub()
        setButton()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("trackerCreationVC.category", comment: "")
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
    
    private func setStubImage() {
        let stubView = UIView()
        stubView.backgroundColor = .none
        stubView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stubView)
        
        let image = UIImage(named: "stubImageForTrackers")
        let stubImageView = UIImageView(image: image)
        stubImageView.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(stubImageView)
        
        let label1 = UILabel()
        label1.text = NSLocalizedString("trackerCreationVC.category.stub.line1", comment: "")
        label1.font = Fonts.sfPro12Medium
        label1.textColor = Colors.generalTextcolor
        label1.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(label1)
        
        let label2 = UILabel()
        label2.text = NSLocalizedString("trackerCreationVC.category.stub.line2", comment: "")
        label2.font = Fonts.sfPro12Medium
        label2.textColor = Colors.generalTextcolor
        label2.translatesAutoresizingMaskIntoConstraints = false
        stubView.addSubview(label2)
        
        self.stubView = stubView
        
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
        self.stubView.isHidden = !viewModel.stubIsHidden
    }
    
    private func setTableView() {
        categoriesTableView.register(CategoryTableCell.self, forCellReuseIdentifier: "cell")
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.backgroundColor = Colors.generalBackground
        categoriesTableView.showsVerticalScrollIndicator = false
        categoriesTableView.separatorColor = Colors.grayCellsSeparator
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
    
    private func setButton() {
        let categoryCreationButton = UIButton()
        categoryCreationButton.addTarget(self, action: #selector(categoryCreationButtonPressed), for: .touchUpInside)
        categoryCreationButton.backgroundColor = Colors.generalTextcolor
        categoryCreationButton.setTitle(NSLocalizedString("trackerCreationVC.addCategory", comment: ""), for: .normal)
        categoryCreationButton.titleLabel?.font = Fonts.sfPro16Medium
        categoryCreationButton.setTitleColor(Colors.generalBackground, for: .normal)
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
    
    private func updateTableView() {
        categoriesTableView.reloadData()
    }
    
    private func dismissVC() {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CategoryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CategoryTableCell {
            
            cell.configure(with: viewModel.getCellParams(for: indexPath.row))
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

// MARK: - UITableViewDelegate
extension CategoryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateSelectedCategory(with: indexPath)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(actionProvider: { actions in
            return UIMenu(children: [
                
                UIAction(title: NSLocalizedString("trackersViewController.contextMenu.edit", comment: "")) { [weak self] _ in
                    if let categoryName = self?.viewModel.categoryList[indexPath.row] {
                        self?.categoryEditButtonPressed(categoryName: categoryName)
                    }
                },
                
                UIAction(title: NSLocalizedString("trackersViewController.contextMenu.delete", comment: ""), attributes: .destructive) { [weak self] _ in
                    if let categoryName = self?.viewModel.categoryList[indexPath.row] {
                        self?.present(self?.getDeleteAlertView(for: categoryName) ?? UIViewController(), animated: true)
                    }
                },
            ])
        })
    }
    
    private func getDeleteAlertView(for categoryName: String) -> UIAlertController {
        let trackersCount = viewModel.getTrackersCountFor(categoryName: categoryName)
        
        if trackersCount > 0 {
            let alert = UIAlertController(title: nil,
                                          message: String(
                                            format: NSLocalizedString("categoryCreationVC.contextMenu.canNotDelete.alert", comment: ""),
                                            String.localizedStringWithFormat(NSLocalizedString("numberOfTrackers", comment: ""), trackersCount)
                                          ),
                                          preferredStyle: .actionSheet
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("buttons.ok", comment: ""),
                                          style: .default) {_ in
                alert.dismiss(animated: true)
            })
            
            return alert
        }
        
        let alert = UIAlertController(title: nil,
                                      message: NSLocalizedString("categoryCreationVC.contextMenu.delete.alert", comment: ""),
                                      preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("trackersViewController.contextMenu.delete", comment: ""),
                                      style: .destructive) {_ in
            self.viewModel.deleteCategory(categoryName: categoryName)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("buttons.cancel", comment: ""),
                                      style: .cancel) {_ in
            alert.dismiss(animated: true)
        })
        
        return alert
    }
}
