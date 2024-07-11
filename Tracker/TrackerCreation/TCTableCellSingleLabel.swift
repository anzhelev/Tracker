//
//  TCTableCellSingleLabel.swift
//  Tracker
//
//  Created by Andrey Zhelev on 29.05.2024.
//
import UIKit

final class TCTableCellSingleLabel: UITableViewCell {
    
    // MARK: - Private Properties
    private lazy var singleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.SFPro17Regular
        label.textColor = Colors.red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        label.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
        return label
    }()
    
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(new cell: CellParams, warningIsShown: Bool) {
 
        switch cell.rounded {
        case .top:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .all:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .none:
            self.layer.maskedCorners = []
        }
 
        separatorInset = cell.separator
        ? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        : UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        
        if warningIsShown {
             singleLabel.text = cell.title
         } 
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.white
    }
}
