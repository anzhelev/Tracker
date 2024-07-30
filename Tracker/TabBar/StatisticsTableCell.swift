//
//  StatisticsTableCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 21.07.2024.
//
import UIKit

final class StatisticsTableCell: UITableViewCell {
    
    // MARK: - Private Properties
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private let bordersView = UIView()
    private var gradientColors = [Colors.gradientRed, Colors.gradientGreen, Colors.gradientBlue]
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with title: String, description: String) {
        separatorInset = UIEdgeInsets(top: 0, left: bounds.midX, bottom: 0, right: bounds.midX)
        
        let gradient = UIImage.gradientImage(bounds: bounds, colors: gradientColors)
        bordersView.layer.borderColor = UIColor(patternImage: gradient).cgColor
        
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        self.selectionStyle = .none
        self.backgroundColor = Colors.generalBackground
        bordersView.backgroundColor = Colors.generalBackground
        bordersView.layer.borderWidth = 1
        bordersView.layer.masksToBounds = true
        bordersView.layer.cornerRadius = 16
        bordersView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bordersView)
        
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.generalTextcolor
        titleLabel.font = Fonts.sfPro34Bold
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bordersView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = Colors.generalTextcolor
        descriptionLabel.font = Fonts.sfPro12Medium
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bordersView.addSubview(descriptionLabel)
        self.descriptionLabel = descriptionLabel
        
        NSLayoutConstraint.activate([
            bordersView.topAnchor.constraint(equalTo: self.topAnchor),
            bordersView.heightAnchor.constraint(equalToConstant: 90),
            bordersView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            bordersView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: bordersView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: bordersView.leadingAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 43),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
