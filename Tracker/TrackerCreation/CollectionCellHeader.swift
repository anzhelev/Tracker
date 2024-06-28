//
//  CollectionCellHeader.swift
//  Tracker
//
//  Created by Andrey Zhelev on 28.05.2024.
//
import UIKit

class CollectionCellHeader: UICollectionReusableView {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private Methods
    private func setTitleLabel() {
        titleLabel.backgroundColor = .clear
        titleLabel.font = Fonts.SFPro19Bold
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}