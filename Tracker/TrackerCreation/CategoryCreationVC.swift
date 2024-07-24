//
//  CategoryCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 21.05.2024.
//
import UIKit

protocol CategoryCreationVCDelegate: AnyObject {
    func addNewCategory(category: String)
    func editCategory(oldName: String, newName: String)
}

final class CategoryCreationVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: CategoryCreationVCDelegate?
    
    // MARK: - Private Properties
    private var editMode = false
    private var doneButton = UIButton()
    private var titleTextField = UITextField()
    private var minimumTitleLength = 1
    private var oldCategoryName: String
    
    // MARK: - Initializers
    init(delegate: CategoryCreationVCDelegate, editMode: Bool, categoryName: String?) {
        self.delegate = delegate
        self.editMode = editMode
        self.oldCategoryName = categoryName ?? ""
        
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
    @objc private func categoryCreationButtonPressed() {
        if let newCaterory = titleTextField.text {
            editMode
            ? self.delegate?.editCategory(oldName: oldCategoryName, newName: newCaterory)
            : self.delegate?.addNewCategory(category: newCaterory)
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        view.backgroundColor = Colors.generalBackground
        setTitle()
        setCategoryNameInputField()
        setButton()
        updateButtonState()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = editMode
        ? NSLocalizedString("categoryCreationVC.title", comment: "")
        : NSLocalizedString("trackerCreationVC.category", comment: "")
        
        titleLabel.font = Fonts.SFPro16Medium
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func setCategoryNameInputField() {
        let titleInputView = UIView()
        titleInputView.backgroundColor = Colors.grayCellBackground
        titleInputView.layer.masksToBounds = true
        titleInputView.layer.cornerRadius = 16
        titleInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleInputView)
        
        let titleTextField = UITextField()
        if editMode {
            titleTextField.text = oldCategoryName
        }
        titleTextField.placeholder = NSLocalizedString("trackerCreationVC.enterCategoryName", comment: "")
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = Colors.generalTextcolor
        titleTextField.delegate = self
        titleTextField.font = Fonts.SFPro17Regular
        titleTextField.enablesReturnKeyAutomatically = false
        titleTextField.addTarget(self, action: #selector(updateButtonState), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleInputView.addSubview(titleTextField)
        self.titleTextField = titleTextField
        
        titleInputView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87).isActive = true
        titleInputView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        titleInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: titleInputView.leadingAnchor, constant: 16).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: titleInputView.trailingAnchor, constant: -10).isActive = true
        titleTextField.centerYAnchor.constraint(equalTo: titleInputView.centerYAnchor).isActive = true
    }
    
    private func setButton() {
        let doneButton = UIButton()
        doneButton.addTarget(self, action: #selector(categoryCreationButtonPressed), for: .touchUpInside)
        doneButton.backgroundColor = Colors.generalTextcolor
        doneButton.setTitle(NSLocalizedString("buttons.done", comment: ""), for: .normal)
        doneButton.titleLabel?.font = Fonts.SFPro16Medium
        doneButton.setTitleColor(Colors.generalBackground, for: .normal)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 16
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(doneButton)
        self.doneButton = doneButton
        
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func updateButtonState() {
        doneButton.isEnabled = titleTextField.text?.count ?? 0 >= minimumTitleLength
        doneButton.backgroundColor = doneButton.isEnabled ? Colors.generalTextcolor : Colors.grayDisabledButton
    }
}

// MARK: - UITextFieldDelegate
extension CategoryCreationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
