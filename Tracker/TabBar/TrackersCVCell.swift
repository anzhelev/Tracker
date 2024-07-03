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
    
    // MARK: - Public Properties
    weak var delegate: TrackersCVCellDelegate?
    
    // MARK: - Private Properties
    private var mainView = UIView()
    private var titleLabel = UITextView()
    private var emojiView = UIImageView()
    private var dayCounLabel = UILabel()
    private var completeButton = UIButton()
    private var completeButtonBGView = UIView()
    private var isEvent = false
    private var isCompleted: Bool = true
    private var trackerID: UUID?
    private var trackerIndexPath: IndexPath?
    private var selectedDate: Date = Date()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(for tracker: Tracker, with index: IndexPath, isEvent: Bool, selectedDate: Date, isCompleted: Bool, daysCount: Int) {
        trackerID = tracker.id
        trackerIndexPath = index
        self.isEvent = isEvent
        self.selectedDate = selectedDate
        self.isCompleted = isCompleted
        
        mainView.backgroundColor = UIColor(named: "Color\(tracker.color ?? 1)")
        titleLabel.text = tracker.name
        dayCounLabel.text = self.isEvent ? "Уникальное" : setStringFor(daysCount)
        setCompleteButtomImage(with: UIColor(named: "Color\(tracker.color ?? 1)"))
        emojiView.image = UIImage(named: "emoji\(tracker.emoji ?? 1)")
    }
    
    // MARK: - IBAction
    /// действие по нажатию кнопки "➕ или ✅"
    @objc private func completeButtonAction() {
        
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
    
    // MARK: - Private Methods
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
        
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiCircleView.addSubview(emojiView)
        
        titleLabel.textAlignment = .left
        titleLabel.font = Fonts.SFPro12Semibold
        titleLabel.textColor = Colors.white
        titleLabel.backgroundColor = .clear
        titleLabel.isUserInteractionEnabled = false
        titleLabel.isSelectable = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(titleLabel)
        
        dayCounLabel.backgroundColor = .clear
        dayCounLabel.textAlignment = .left
        dayCounLabel.textColor = Colors.black
        dayCounLabel.font = Fonts.SFPro12Semibold
        dayCounLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dayCounLabel)
        
        completeButtonBGView.layer.masksToBounds = true
        completeButtonBGView.layer.cornerRadius = 17
        completeButtonBGView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(completeButtonBGView)
        
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
            completeButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -7),
            
            completeButtonBGView.centerXAnchor.constraint(equalTo: completeButton.centerXAnchor),
            completeButtonBGView.centerYAnchor.constraint(equalTo: completeButton.centerYAnchor),
            completeButtonBGView.heightAnchor.constraint(equalToConstant: 34),
            completeButtonBGView.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setCompleteButtomImage(with color: UIColor?) {
                guard let image = isCompleted ? UIImage(named: "doneSignForCell") : UIImage(named: "plusButtonForCell") else {
                    return
                }
        switch isCompleted {
            
        case true:
            completeButtonBGView.backgroundColor = color?.withAlphaComponent(0.3)
            let buttonImage = image.withRenderingMode(.alwaysOriginal)
            completeButton.setImage(buttonImage, for: .normal)
            completeButton.tintColor = .clear
            
        case false:
            completeButtonBGView.backgroundColor = Colors.white
            let buttonImage = image.withRenderingMode(.alwaysTemplate)
            completeButton.setImage(buttonImage, for: .normal)
            completeButton.tintColor = color
        }
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
