//
//  TrackersCVCell.swift
//  Tracker
//
//  Created by Andrey Zhelev on 23.05.2024.
//

import UIKit

protocol TrackersCVCellDelegate: AnyObject {
    func updateTrackerStatus(trackerID: UUID, indexPath: IndexPath, completeStatus: Bool)
}

final class TrackersCVCell: UICollectionViewCell {
    
    weak var delegate: TrackersCVCellDelegate?
    
    private var mainView = UIView()
    private var titleLabel = UITextView()
    private var emoji = UIImage(named: "emoji_01")  //🙂
    private var dayCounLabel = UILabel()
    private var completeButton = UIButton()
    private var isEvent = false
    private var isCompleted: Bool = true
    private var trackerID: UUID?
    private var trackerIndexPath: IndexPath?
    private var selectedDate: Date = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for tracker: Tracker, with index: IndexPath, isEvent: Bool, selectedDate: Date, isCompleted: Bool, daysCount: Int) {
        trackerID = tracker.id
        trackerIndexPath = index
        self.isEvent = isEvent
        self.selectedDate = selectedDate
        self.isCompleted = isCompleted
        
        mainView.backgroundColor = tracker.color
        titleLabel.text = tracker.name
        dayCounLabel.text = self.isEvent ? "Уникальное" : setStringFor(daysCount)
        completeButton.tintColor = tracker.color
        setCompleteButtomImage()
    }
    
    private func configureUIElements() {
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 16
        mainView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mainView)
        
        let emojiCircleView = UIView()
        emojiCircleView.backgroundColor = Colors.whiteEmojiCircle
        emojiCircleView.layer.masksToBounds = true
        emojiCircleView.layer.cornerRadius = 12
        emojiCircleView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(emojiCircleView)
        
        let emojiView = UIImageView()
        emojiView.image = emoji
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiCircleView.addSubview(emojiView)
        
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: SFPro.bold, size: 12)
        titleLabel.textColor = Colors.white
        titleLabel.backgroundColor = .clear
        titleLabel.isUserInteractionEnabled = false
        titleLabel.isSelectable = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(titleLabel)
        
        dayCounLabel.backgroundColor = .clear
        dayCounLabel.textAlignment = .left
        dayCounLabel.textColor = Colors.black
        dayCounLabel.font = UIFont(name: SFPro.semibold, size: 12)
        dayCounLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dayCounLabel)
        
        setCompleteButtomImage()
        completeButton.addTarget(self, action: #selector(completeButtonAction), for: .touchUpInside)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(completeButton)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiCircleView.heightAnchor.constraint(equalToConstant: 24),
            emojiCircleView.widthAnchor.constraint(equalToConstant: 24),
            emojiCircleView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 12),
            emojiCircleView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            
            emojiView.heightAnchor.constraint(equalToConstant: 16),
            emojiView.widthAnchor.constraint(equalToConstant: 16),
            emojiView.centerXAnchor.constraint(equalTo: emojiCircleView.centerXAnchor),
            emojiView.centerYAnchor.constraint(equalTo: emojiCircleView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiCircleView.bottomAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -12),
            
            dayCounLabel.heightAnchor.constraint(equalToConstant: 18),
            dayCounLabel.topAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 16),
            dayCounLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 12),
            dayCounLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -12),
            
            completeButton.centerYAnchor.constraint(equalTo: dayCounLabel.centerYAnchor),
            completeButton.heightAnchor.constraint(equalToConstant: 44),
            completeButton.widthAnchor.constraint(equalToConstant: 44),
            completeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -7)
        ])
    }
    
    /// действие по нажатию кнопки "＋"
    @objc func completeButtonAction() {
        
        let tomorrow = Calendar.current.startOfDay(for: Date()) + 86400
        
        guard selectedDate < tomorrow else {
            print("Попытка отметить выполнение трекера на будущую дату")
            return
        }
        
        isCompleted.toggle()
        guard let trackerID,
              let trackerIndexPath else {
            assertionFailure("Отсутствуют данные по трекеру")
            return
        }
        delegate?.updateTrackerStatus(trackerID: trackerID, indexPath: trackerIndexPath, completeStatus: isCompleted)
    }
    
    private func setCompleteButtomImage() {
        guard let buttonImage = isCompleted ? UIImage(named: "checkSignButtonForCell") : UIImage(named: "plusButtonForCell") else {
            return
        }
        completeButton.setImage(buttonImage, for: .normal)
    }
    
    private func setStringFor(_ count: Int) -> String {
        let days = count % 10
        switch days {
        case 0, 5, 6, 7, 8, 9:
            return "\(count) дней"
        case 1:
            return "\(count) день"
        case 2, 3, 4:
            return "\(count) дня"
        default:
            return ""
        }
    }
}
