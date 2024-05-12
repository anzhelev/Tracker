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
        
        switch newTrackerType {
        case .habit:
            configureUIElementsForHabit()
        case .event:
            configureUIElementsForEvent()
        }
        
    }
    
    private func configureUIElementsForEvent() {
        setTitle(forTracker: .event)
        
        
    }
    
    private func configureUIElementsForHabit() {
        setTitle(forTracker: .habit)
        
    }
    
    private func setTitle(forTracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = forTracker == .habit ? "Привычка" : "Нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        
        var newTrackerTitleInputView = UIView()
        newTrackerTitleInputView.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerTitleInputView.layer.masksToBounds = true
        newTrackerTitleInputView.layer.cornerRadius = 16
        newTrackerTitleInputView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerTitleInputView)
        
        let titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = .trBlack
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        newTrackerTitleInputView.addSubview(titleTextField)
        
        
        //        var textArea = UIView()
        //        textArea.layer.masksToBounds = true
        //        textArea.autoresizesSubviews = true
        //        textArea.translatesAutoresizingMaskIntoConstraints = false
        //        newTrackerTitleInputView.addSubview(textArea)
        //
        //        var newTrackerTitleTextView = UITextView()
        //        newTrackerTitleTextView = UITextView(frame: textArea.bounds)
        //        newTrackerTitleTextView.isEditable = true
        //        newTrackerTitleTextView.textColor = .trBlack
        //        newTrackerTitleTextView.backgroundColor = .lightGray
        //        newTrackerTitleTextView.text = "adfasdfasfasdfasdfasdfasdf adfadgf"
        //        newTrackerTitleTextView.font = UIFont(name: SFPro.regular, size: 17)
        //        newTrackerTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        //        textArea.addSubview(newTrackerTitleTextView)
        
        //        guard let image = UIImage(named: "newTrackerTitleInputCancelButton") else { return }
        //        let inputCancelButton = UIButton.systemButton(with: image, target: self, action: #selector(textInputCancel))
        //        inputCancelButton.tintColor = .lightGray// .trNewTrackerTitleInputCancelButton
        //        inputCancelButton.translatesAutoresizingMaskIntoConstraints = false
        //        newTrackerTitleInputView.addSubview(inputCancelButton)
        //        self.inputCancelButton = inputCancelButton
        //        inputCancelButton.isHidden = true
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            newTrackerTitleInputView.heightAnchor.constraint(equalToConstant: 75),
            newTrackerTitleInputView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            newTrackerTitleInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerTitleInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            titleTextField.centerYAnchor.constraint(equalTo: newTrackerTitleInputView.centerYAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: newTrackerTitleInputView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: newTrackerTitleInputView.trailingAnchor, constant: -16)
            
//            textArea.leadingAnchor.constraint(equalTo: newTrackerTitleInputView.leadingAnchor, constant: 16),
//            textArea.topAnchor.constraint(equalTo: newTrackerTitleInputView.topAnchor, constant: 16),
//            textArea.bottomAnchor.constraint(equalTo: newTrackerTitleInputView.bottomAnchor, constant: -16),
//            textArea.trailingAnchor.constraint(equalTo: newTrackerTitleInputView.trailingAnchor, constant: -70),
            
//            newTrackerTitleTextView.leadingAnchor.constraint(equalTo: textArea.leadingAnchor, constant: 0),
            //            newTrackerTitleTextView.trailingAnchor.constraint(equalTo: textArea.trailingAnchor, constant: 0),
            //            newTrackerTitleTextView.bottomAnchor.constraint(greaterThanOrEqualTo: textArea.bottomAnchor, constant: 0),
            //            newTrackerTitleTextView.topAnchor.constraint(greaterThanOrEqualTo: textArea.topAnchor, constant: 0)
            //            newTrackerTitleTextView.bottomAnchor.constraint(greaterThanOrEqualTo: textArea.bottomAnchor, constant: 6)
            
            //            inputCancelButton.heightAnchor.constraint(equalToConstant: 44),
            //            inputCancelButton.widthAnchor.constraint(equalToConstant: 44),
            //            inputCancelButton.centerYAnchor.constraint(equalTo: newTrackerTitleInputView.centerYAnchor),
            //            inputCancelButton.leadingAnchor.constraint(equalTo: newTrackerTitle.trailingAnchor, constant: 25),
            //            inputCancelButton.trailingAnchor.constraint(equalTo: newTrackerTitleInputView.trailingAnchor)
        ])
        
    }
    
    @objc private func textInputCancel() {
        
    }
}
