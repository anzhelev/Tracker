//
//  NTCTableCellwithCollection.swift
//  Tracker
//
//  Created by Andrey Zhelev on 28.05.2024.
//
import UIKit

protocol NTCTableCellwithCollectionDelegate: AnyObject {
    func updateNewTracker(dataType: CellID, value: Int?)
}

final class NTCTableCellwithCollection: UITableViewCell {
    
    // MARK: - Public Properties
    weak var delegate: NTCTableCellwithCollectionDelegate?
    
    
    // MARK: - Private Properties
    private var collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var headerTitle: String = ""
    private enum CellReuseID: String {
        case emoji = "emojiCell"
        case color = "colorCell"
    }
    private var collectionID: CellID = .emoji
    private var cellHeight: CGFloat = 0
    private var selectedCell: Int?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
        setCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(new cell: MainTableCellParams, with selectedItem: Int?) {
        headerTitle = cell.title
        cellHeight = cell.cellHeight
        selectedCell = selectedItem
        separatorInset = UIEdgeInsets(top: 0, left: self.bounds.midX, bottom: 0, right: self.bounds.midX)
        
        switch cell.id {
            
        case .emoji:
            collectionID = .emoji
            collection.register(EmojiCollectionCell.self, forCellWithReuseIdentifier: CellReuseID.emoji.rawValue)
        case .color:
            collectionID = .color
            collection.register(ColorCollectionCell.self, forCellWithReuseIdentifier: CellReuseID.color.rawValue)
        default:
            return
        }
        
    }
    
    // MARK: - IBAction
    @objc private func completeButtonAction() {
        
    }
    
    // MARK: - Private Methods
    private func setUIElements() {
        backgroundColor = Colors.white
    }
    
    private func setCollection() {
        collection.dataSource = self
        collection.delegate = self
        collection.register(CollectionCellHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collection.backgroundColor = Colors.white
        collection.showsVerticalScrollIndicator = false
        collection.isScrollEnabled = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            collection.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 2),
            collection.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -2)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension NTCTableCellwithCollection: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIsSelected = selectedCell == indexPath.item
        
        switch collectionID {
            
        case .emoji:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseID.emoji.rawValue, for: indexPath) as? EmojiCollectionCell {
                cell.configure(withEmoji: indexPath.item + 1, isSelected: cellIsSelected)
                return cell
            }
            
        case .color:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellReuseID.color.rawValue, for: indexPath) as? ColorCollectionCell {
                cell.configure(withColor: indexPath.item + 1, isSelected: cellIsSelected)
                return cell
            }
        default:
            break
        }
        fatalError("Проблема с подготовкой ячейки")
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionCellHeader {
            headerView.configure(with: headerTitle)
            return headerView
        }
        fatalError("Проблема с подготовкой хедера")
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NTCTableCellwithCollection: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellHeight, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

// MARK: - UICollectionViewDelegate
extension NTCTableCellwithCollection: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch selectedCell {
        case nil:
            selectedCell = indexPath.item
            collection.reloadItems(at: [indexPath])
        case indexPath.item:
            selectedCell = nil
            collection.reloadItems(at: [indexPath])
        default:
            let indexes: [IndexPath] = [IndexPath(item: selectedCell ?? 0, section: 0), indexPath]
            selectedCell = indexPath.item
            collection.reloadItems(at: indexes)
        }
        self.delegate?.updateNewTracker(dataType: collectionID, value: selectedCell)
    }
}
