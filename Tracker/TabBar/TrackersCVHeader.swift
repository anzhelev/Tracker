//
//  TrackersCVHeader.swift
//  Tracker
//
//  Created by Andrey Zhelev on 23.05.2024.
//

import UIKit

class TrackersCVHeader: UICollectionReusableView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private func setTitleLabel() {
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont(name: SFPro.bold, size: 19)
        titleLabel.textAlignment = .left
        titleLabel.textColor = Colors.black
        //        self.contentMode = .topLeft
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
