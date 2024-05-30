//
//  TCTableCellDoubleLabel.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.05.2024.
//
import UIKit

final class TCTableCellDoubleLabel: UITableViewCell {

    // MARK: - Private Properties
    private let rowSpacing: CGFloat = 3
    private var titleLabel = UILabel()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFPro17Regular
        label.textColor = Colors.grayDisabledButton
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        label.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing).isActive = true
        label.heightAnchor.constraint(equalTo: titleLabel.heightAnchor).isActive = true
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
        setTitleLabel()
        addChevron()
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
        
        if cell.value != nil && valueLabel.text == nil {
            self.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: rowSpacing/2).isActive = true
            valueLabel.text = cell.value
        } else if cell.value != nil {
            valueLabel.text = cell.value
        }
        titleLabel.text = cell.title
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.grayCellBackground
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16
    }
    
    private func setTitleLabel() {
        titleLabel.font = Fonts.SFPro17Regular
        titleLabel.textColor = Colors.black
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func addChevron() {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = Colors.grayDisabledButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(chevron)
        chevron.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -33).isActive = true
    }
}
