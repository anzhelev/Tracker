//
//  ColorCollectionCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 28.05.2024.
//
import UIKit

final class ColorCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private var backgroundCellView = UIView()
    private var colorView = UIView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(withColor number: Int, isSelected: Bool) {
        guard let cellColor  = UIColor(named: "Color\(number)") else {
            return
        }
        colorView.backgroundColor = cellColor
        backgroundCellView.layer.borderColor = isSelected ? cellColor.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 12
        backgroundCellView.layer.borderWidth = 3
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backgroundCellView)

        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            backgroundCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            colorView.centerXAnchor.constraint(equalTo: backgroundCellView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            colorView.widthAnchor.constraint(equalTo: backgroundCellView.widthAnchor, constant: -12),
            colorView.heightAnchor.constraint(equalTo: backgroundCellView.heightAnchor, constant: -12)
        ])
    }
}
