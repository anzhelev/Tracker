//
//  CategoryTableCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 10.07.2024.
//
import UIKit

final class CategoryTableCell: UITableViewCell {
    
    // MARK: - Private Properties
    private var titleLabel = UILabel()
    private var checkMarkImageView = UIImageView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with params: CategoryTableCellParams) {
        
        titleLabel.text = params.title
        
        switch params.corners {
        case .top:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner,]
        case .all:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .none:
            self.layer.maskedCorners = []
        }
        
        separatorInset = params.separator
        ? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        : UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        
        checkMarkImageView.isHidden = !params.isSelected
    }
        
    // MARK: - Private Methods
    private func setUIElements() {
        //        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        self.selectionStyle = .none
        self.backgroundColor = Colors.grayCellBackground
        self.layer.masksToBounds = true
        self.selectionStyle = .none
        self.layer.cornerRadius = 16
        
        let label = UILabel()
        label.text = ""
        label.textColor = Colors.black
        label.font = Fonts.SFPro17Regular
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        self.titleLabel = label
        
        let image = UIImage(named: "checksign")
        let checkMarkImageView = UIImageView(image: image)
        checkMarkImageView.tintColor = Colors.blue
        checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(checkMarkImageView)
        checkMarkImageView.isHidden = true
        self.checkMarkImageView = checkMarkImageView

        label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkMarkImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkMarkImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -21).isActive = true
    }
}

