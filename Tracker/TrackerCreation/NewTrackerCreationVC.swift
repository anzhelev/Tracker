//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 12.05.2024.
//

import UIKit

enum TrackerType: String {
    case habit
    case event
}

final class NewTrackerCreationVC: UIViewController {
    
    let newTrackerType: TrackerType
    weak var delegate: NewTrackerTypeChoiceVC?
    
    private var inputCancelButton = UIButton()
    private var newTrackerTitleView = UIView()
    private var newTrackerAddCategoryButton = UIButton()
    private var newTrackerAddScheduleButton = UIButton()
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    
    
    init(newTrackerType: TrackerType, delegate: NewTrackerTypeChoiceVC? = nil) {
        self.newTrackerType = newTrackerType
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .trWhite
        
        configureUIElements(for : newTrackerType)
    }
    
    private func configureUIElements(for tracker : TrackerType) {
        setTitle(for: tracker)
        setCategoryButton(for: tracker)
        if tracker == .habit {
            setScheduleButton()
        }
        setBottomButtons()
    }
    
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let newTrackerTitleView = UIView()
        newTrackerTitleView.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerTitleView.layer.masksToBounds = true
        newTrackerTitleView.layer.cornerRadius = 16
        newTrackerTitleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerTitleView)
        self.newTrackerTitleView = newTrackerTitleView
        
        let titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = .trBlack
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        newTrackerTitleView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            newTrackerTitleView.heightAnchor.constraint(equalToConstant: 75),
            newTrackerTitleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            newTrackerTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerTitleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            titleTextField.centerYAnchor.constraint(equalTo: newTrackerTitleView.centerYAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: newTrackerTitleView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: newTrackerTitleView.trailingAnchor, constant: -16)
        ])
        
    }
    
    
    private func setTitle_2(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let newTrackerTitleInputView = UIView()
        newTrackerTitleInputView.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerTitleInputView.layer.masksToBounds = true
        newTrackerTitleInputView.layer.cornerRadius = 16
        newTrackerTitleInputView.translatesAutoresizingMaskIntoConstraints = false
        
        let textView = UITextView()
        textView.isEditable = true
        textView.textContainerInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        //        textView.
        textView.textColor = .trBlack
        textView.backgroundColor = .lightGray
        textView.text = "Введите название трекера"
        textView.font = UIFont(name: SFPro.regular, size: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        
        guard let image = UIImage(named: "newTrackerTitleInputCancelButton") else { return }
        let inputCancelButton = UIButton.systemButton(with: image, target: self, action: #selector(textInputCancel))
        inputCancelButton.tintColor = .lightGray// .trNewTrackerTitleInputCancelButton
        inputCancelButton.translatesAutoresizingMaskIntoConstraints = false
        newTrackerTitleInputView.addSubview(inputCancelButton)
        self.inputCancelButton = inputCancelButton
        inputCancelButton.isHidden = false
        
        newTrackerTitleInputView.addSubview(textView)
        newTrackerTitleInputView.addSubview(inputCancelButton)
        view.addSubview(newTrackerTitleInputView)
        view.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            newTrackerTitleInputView.heightAnchor.constraint(equalToConstant: 75),
            newTrackerTitleInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            newTrackerTitleInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerTitleInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            //            textView.heightAnchor.constraint(lessThanOrEqualToConstant: 54),
            textView.centerYAnchor.constraint(equalTo: newTrackerTitleInputView.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: newTrackerTitleInputView.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: inputCancelButton.trailingAnchor, constant: -44),
            textView.bottomAnchor.constraint(equalTo: newTrackerTitleInputView.bottomAnchor, constant: 0),
            textView.topAnchor.constraint(equalTo: newTrackerTitleInputView.topAnchor, constant: 0),
            
            inputCancelButton.heightAnchor.constraint(equalToConstant: 17),
            inputCancelButton.widthAnchor.constraint(equalToConstant: 17),
            inputCancelButton.centerYAnchor.constraint(equalTo: newTrackerTitleInputView.centerYAnchor),
            inputCancelButton.trailingAnchor.constraint(equalTo: newTrackerTitleInputView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setCategoryButton(for tracker: TrackerType) {
        let newTrackerAddCategoryButton = UIButton()
        newTrackerAddCategoryButton.addTarget(self, action: #selector(setCategoryButtonPressed), for: .touchUpInside)
        newTrackerAddCategoryButton.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerAddCategoryButton.layer.masksToBounds = true
        if tracker == .habit {
            newTrackerAddCategoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        newTrackerAddCategoryButton.layer.cornerRadius = 16
        newTrackerAddCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerAddCategoryButton)
        self.newTrackerAddCategoryButton = newTrackerAddCategoryButton
        
        NSLayoutConstraint.activate([
            newTrackerAddCategoryButton.heightAnchor.constraint(equalToConstant: 75),
            newTrackerAddCategoryButton.topAnchor.constraint(equalTo: newTrackerTitleView.bottomAnchor, constant: 24),
            newTrackerAddCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerAddCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            
        ])
        addChevronOnButton(on: newTrackerAddCategoryButton)
    }
    
    private func setScheduleButton() {
        let newTrackerAddScheduleButton = UIButton()
        newTrackerAddScheduleButton.addTarget(self, action: #selector(setScheduleButtonPressed), for: .touchUpInside)
        newTrackerAddScheduleButton.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerAddScheduleButton.layer.masksToBounds = true
        newTrackerAddScheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newTrackerAddScheduleButton.layer.cornerRadius = 16
        newTrackerAddScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerAddScheduleButton)
        self.newTrackerAddScheduleButton = newTrackerAddScheduleButton
        
        let buttonDivider = UIView()
        buttonDivider.backgroundColor = .trTabBarUpperlineAlpha30
        buttonDivider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonDivider)
        
        NSLayoutConstraint.activate([
            newTrackerAddScheduleButton.heightAnchor.constraint(equalToConstant: 75),
            newTrackerAddScheduleButton.topAnchor.constraint(equalTo: newTrackerAddCategoryButton.bottomAnchor, constant: 0),
            newTrackerAddScheduleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerAddScheduleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonDivider.heightAnchor.constraint(equalToConstant: 0.5),
            buttonDivider.centerYAnchor.constraint(equalTo: newTrackerAddScheduleButton.topAnchor, constant: 0),
            buttonDivider.leadingAnchor.constraint(equalTo: newTrackerAddScheduleButton.leadingAnchor, constant: 16),
            buttonDivider.trailingAnchor.constraint(equalTo: newTrackerAddScheduleButton.trailingAnchor, constant: -16)
        ])
        addChevronOnButton(on: newTrackerAddScheduleButton)
    }
    
    private func addChevronOnButton(on buttonView: UIView) {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = .trNewTrackerTitleInputCancelButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -33)
        ])
        
    }
    
    private func setBottomButtons() {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.backgroundColor = .trWhite
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        cancelButton.setTitleColor(.trCancelButtonText, for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.trCancelButtonText.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        createButton.backgroundColor = .trTabBarUpperlineAlpha30 // .trNewTrackerTitleInputCancelButton
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        createButton.setTitleColor(.trWhite, for: .normal)
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        //        createButton.isEnabled = false
        self.createButton = createButton
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func setCategoryButtonPressed() {
        print("CONSOLE: setCategoryButtonPressed" )
    }
    
    @objc private func setScheduleButtonPressed() {
        print("CONSOLE: setScheduleButtonPressed" )
    }
    
    @objc private func cancelButtonPressed() {
        print("CONSOLE: cancelButtonPressed" )
    }
    
    @objc private func createButtonPressed() {
        print("CONSOLE: createButtonPressed" )
    }
        
    @objc private func textInputCancel() {
        print("CONSOLE: " )
        newTrackerAddCategoryButton.backgroundColor = .gray
    }
}
