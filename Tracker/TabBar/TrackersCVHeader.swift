//
//  TrackersCVHeader.swift
//  Tracker
//
//  Created by Andrey Zhelev on 23.05.2024.
//
import UIKit

class TrackersCVHeader: UICollectionReusableView {
    
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
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
