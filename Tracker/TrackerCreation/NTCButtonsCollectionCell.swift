//
//  NTCButtonsCollectionCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 15.05.2024.
//
import UIKit

enum DividerPosition: String {
    case top
    case bottom
    case both
}

final class NTCButtonsCollectionCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    private var titleTextColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(new cell: MainCVCellParams, for tracker: TrackerType) {
        
        if cell.id == .spacer {
            self.backgroundColor = .none
        } else {
            self.backgroundColor = .trNewTrackerTitleBGAlpha30
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 16
        }
        
        switch cell.id {
        case .category:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            if tracker == .habit {
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                addDivider(position: .bottom)
            }
        case .shedule:
            addChevron()
            addLabels(title: cell.title, value: cell.value)
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            addDivider(position: .top)
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
        titleTextField.textColor = .trBlack
        if let value {
            titleTextField.text = value
        }
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
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
        titleLabel.textColor = .trBlack
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        
        guard let value else {
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            return
        }
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont(name: SFPro.regular, size: 17)
        valueLabel.textColor = .trTabBarUpperlineAlpha30
        valueLabel.textAlignment = .left
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(valueLabel)
        
        let rowSpacing: CGFloat = 3
        self.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing/2).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing).isActive = true
    }
    
    private func addChevron() {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = .trNewTrackerTitleInputCancelButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -33)
        ])
    }
    
    private func addDivider(position: DividerPosition) {
        let divider = UIView()
        divider.backgroundColor = .trTabBarUpperlineAlpha30
        divider.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(divider)
        switch position {
        case .top:
            divider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        case .bottom:
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        case .both:
            break
        }
        divider.heightAnchor.constraint(equalToConstant: 0.25).isActive = true
        divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        divider.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
}
