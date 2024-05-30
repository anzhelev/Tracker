//
//  TCTableCellTextInput.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.05.2024.
//
import UIKit

protocol TCTableCellTextInputDelegate: AnyObject {
    func updateNewTrackerName(with title: String?)
}

final class TCTableCellTextInput: UITableViewCell {
    
    // MARK: - Public Properties
    weak var delegate: TCTableCellTextInputDelegate?
    
    
    // MARK: - Private Properties
    private var titleTextField = UITextField()
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
        addTitleTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(new cell: CellParams) {
        switch cell.rounded {
        case .top:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner,]
        case .all:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .none:
            self.layer.maskedCorners = []
        }
        
        switch cell.separator {
            
        case true:
            separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        case false:
            separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        }
        
        titleTextField.placeholder = cell.title
        if let title = cell.value {
            titleTextField.text = title
        }
    }
    
    // MARK: - IBAction
    @objc func updateTitle() {
        self.delegate?.updateNewTrackerName(with: self.titleTextField.text)
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.grayCellBackground
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func addTitleTextField() {
        titleTextField = UITextField()
        titleTextField.delegate = self
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = Colors.black
        
        titleTextField.font = Fonts.SFPro17Regular
        titleTextField.enablesReturnKeyAutomatically = false
        titleTextField.addTarget(self, action: #selector(updateTitle), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleTextField)
        
        titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        titleTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
}

// MARK: - UITextFieldDelegate
extension TCTableCellTextInput: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return false
    }
}
