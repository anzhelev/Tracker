//
//  NTCButtonCollectionView.swift
//  Tracker
//
//  Created by Andrey Zhelev on 15.05.2024.
//
import UIKit

enum ConfigType: String {
    case eventCategoyy
    case habitCategory
    case habitShedule
}

struct CollectionParams {
    let configType: ConfigType
    var rowCount: Int = 1
    let minimumRowSpacing: CGFloat = 0
    let collectionViewHeight: CGFloat = 75
    let cellHeight: CGFloat = 23
    let leftInset: CGFloat = 16
    let rightInset: CGFloat = 50
    let cornerRadius: CGFloat = 16
    let backgroundNormal: UIColor = .trNewTrackerTitleBGAlpha30
    let backgroundSelected: UIColor = .trSearchFieldBackgroundAlpha12
    let cellFont = UIFont(name: SFPro.regular, size: 17)
    let mainCellFontColor: UIColor = .trBlack
    let additionalCellFontColor: UIColor = .trSearchFieldText
    let mainCellText: String
    let additionalCellText: String? = nil
    
    init(configType: ConfigType, rowCount: Int) {
        self.configType = configType
        self.rowCount = rowCount
        switch configType {
        case .eventCategoyy, .habitCategory:
            self.mainCellText = "Категория"
        case .habitShedule:
            self.mainCellText = "Расписание"
        }
    }
}

final class NTCButtonCollectionView: UICollectionView {
    
    var params: CollectionParams
    
    init(using params: CollectionParams) {
        self.params = params
        
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
 
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(vcView: UIView) {
        self.backgroundColor = self.params.backgroundNormal
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.params.cornerRadius
        switch self.params.configType {
        case .habitCategory:
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .habitShedule:
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .eventCategoyy: break
        }
        //
        self.translatesAutoresizingMaskIntoConstraints = false
        vcView.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 75),
            self.leadingAnchor.constraint(equalTo: vcView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.trailingAnchor.constraint(equalTo: vcView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        setContentInsets()
    }
    
    func setContentInsets() {
        let inset = max((75 - self.params.cellHeight * CGFloat(self.params.rowCount)) / 2 - self.params.minimumRowSpacing, 0)
        self.contentInset.top = inset
        self.contentInset.left = 16
        self.contentInset.right = 50
    }
}
