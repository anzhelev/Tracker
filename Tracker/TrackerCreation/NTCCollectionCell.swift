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

final class NTCCollectionCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    private var titleTextColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(new cell: MainCVCellParams, for tracker: TrackerType) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        if cell.id == .spacer {
            self.backgroundColor = .none
        } else {
            self.backgroundColor = Colors.grayCellBackground
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 16
        }
        
        switch cell.id {
        case .category:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            if tracker == .habit {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        case .separator:
            self.layer.cornerRadius = .zero
            addSeparator()
        case .shedule:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .title:
            addTitleTextField(placeholder: cell.title, value: cell.value)
        default:
            break
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
//        titleTextField.inputDelegate
//        titleTextField.addAction(UIAction, for: .valueChanged)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleTextField)
        
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
        self.addSubview(titleLabel)
                
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont(name: SFPro.regular, size: 17)
        valueLabel.textColor = Colors.grayDisabledButton
        valueLabel.textAlignment = .left
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rowSpacing: CGFloat = 3
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
                
        if value != nil {
            self.addSubview(valueLabel)
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 50).isActive = true
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing).isActive = true
            self.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing/2).isActive = true
        } else {
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
    }
    
    private func addChevron() {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = Colors.grayDisabledButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -33)
        ])
    }
    
    private func addSeparator() {
        let sellSeparator = UIView()
        sellSeparator.backgroundColor = Colors.grayDisabledButton
        sellSeparator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sellSeparator)
        sellSeparator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sellSeparator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sellSeparator.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        sellSeparator.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
