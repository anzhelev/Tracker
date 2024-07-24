//
//  TCTableCellSpacer.swift
//  Tracker
//
//  Created by Andrey Zhelev on 30.05.2024.
//
import UIKit

final class TCTableCellSpacer: UITableViewCell {
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
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
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .all:
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .none:
            self.layer.maskedCorners = []
        }
        
        separatorInset = cell.separator
        ? UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        : UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.generalBackground
    }
    
}
