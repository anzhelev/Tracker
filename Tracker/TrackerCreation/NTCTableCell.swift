//
//  NTCButtonsCollectionCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 15.05.2024.
//
import UIKit

enum SeparatorPosition: String {
    case top
    case bottom
    case both
}

final class NTCTableCell: UITableViewCell {
    
    weak var delegate: NewTrackerCreationVC?
    private var titleLabel = UILabel()
    private var titleTextColor = UIColor()
    private var titleTextField = UITextField()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func configure(new cell: MainTableCellParams, for tracker: TrackerType) {
        self.selectionStyle = .none
        self.backgroundColor = Colors.grayCellBackground
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
        
        switch cell.id {
        case .category:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            if tracker == .habit {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            } else {
                self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
            }
        case .shedule:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        case .title:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
            addTitleTextField(placeholder: cell.title, value: cell.value)
        case .spacer:
            self.backgroundColor = .none
            self.layer.maskedCorners = []
            self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        }
    }
    
    private func addTitleTextField(placeholder: String, value: String?) {
        let titleTextField = UITextField()
        titleTextField.placeholder = placeholder
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = Colors.black
        if let value {
            titleTextField.text = value
        }
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
        titleTextField.enablesReturnKeyAutomatically = true
        titleTextField.addTarget(self, action: #selector(updateNewTrackerName), for: .editingChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleTextField)
        self.titleTextField = titleTextField
        
        titleTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        titleTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func addLabels(title: String, value: String?) {
        let titleLabel  = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: SFPro.regular, size: 17)
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont(name: SFPro.regular, size: 17)
        valueLabel.textColor = Colors.grayDisabledButton
        valueLabel.textAlignment = .left
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rowSpacing: CGFloat = 3
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        if value != nil {
            self.contentView.addSubview(valueLabel)
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 50).isActive = true
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing).isActive = true
            self.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing/2).isActive = true
        } else {
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
    }
    
    @objc func updateNewTrackerName() {
        self.delegate?.updateNewTrackerName(with: self.titleTextField.text)
    }
    
    private func addChevron() {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = Colors.grayDisabledButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -33)
        ])
    }
}
