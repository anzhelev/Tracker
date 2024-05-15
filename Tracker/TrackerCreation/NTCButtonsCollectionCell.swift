//
//  NTCButtonsCollectionCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 15.05.2024.
//

import UIKit

enum CellType: String {
    case title
    case value
}


final class NTCButtonsCollectionCell: UICollectionViewCell {
    
    private var titleLabel = UILabel()
    private var titleTextColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel(for cell: CellType, with text: String) {
        titleLabel.text = text
        titleLabel.textColor = cell == .title ? .trBlack : .trSearchFieldText
    }
    
    private func configCell() {
        self.backgroundColor = .none
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: SFPro.regular, size: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
