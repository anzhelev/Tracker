//
//  EmojiCollectionCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 28.05.2024.
//
import UIKit

final class EmojiCollectionCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private var backgroundCellView = UIView()
    private var emojiView = UIImageView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(withEmoji number: Int, isSelected: Bool) {
        let emoji = UIImage(named: "emoji\(number)")
        emojiView.image = emoji
        backgroundCellView.backgroundColor = isSelected ? Colors.grayCellBackground.withAlphaComponent(1) : .clear
    }
    
    // MARK: - Private Methods
    private func configureUIElements() {
        backgroundCellView.layer.masksToBounds = true
        backgroundCellView.layer.cornerRadius = 16
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(backgroundCellView)
        
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(emojiView)
        
        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            backgroundCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            emojiView.centerXAnchor.constraint(equalTo: backgroundCellView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: backgroundCellView.centerYAnchor),
            emojiView.widthAnchor.constraint(equalTo: backgroundCellView.widthAnchor, multiplier: 0.62),
            emojiView.heightAnchor.constraint(equalTo: backgroundCellView.heightAnchor, multiplier: 0.62)
        ])
    }
}
