//
//  CategoryCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 21.05.2024.
//
import UIKit

final class CategoryCreationVC: UIViewController {
    
    // MARK: - Public Properties
    weak var delegate: CategoryVC?
    
    // MARK: - Private Properties
    private var doneButton = UIButton()
    private var titleTextField = UITextField()
    private var minimumTitleLength = 1
    
    // MARK: - Initializers
    init(delegate: CategoryVC) {
        self.delegate = delegate
        
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
            self.delegate?.categories.insert(newCaterory)
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        view.backgroundColor = Colors.white
        setTitle()
        setCategoryNameInputField()
        setButton()
        updateButtonState()
    }
    
    private func setTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Категория"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = Colors.black
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
        titleTextField.placeholder = "Введите название категории"
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = Colors.black
        titleTextField.delegate = self
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
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
        doneButton.backgroundColor = Colors.black
        doneButton.setTitle("Готово", for: .normal)
        doneButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        doneButton.setTitleColor(Colors.white, for: .normal)
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
        doneButton.backgroundColor = doneButton.isEnabled ? Colors.black : Colors.grayDisabledButton
    }
}

// MARK: - UITextFieldDelegate
extension CategoryCreationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
