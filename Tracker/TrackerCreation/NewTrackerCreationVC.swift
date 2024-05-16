//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 16.05.2024.
//
import UIKit

enum TrackerType: String {
    case habit
    case event
}

enum CellID: String {
    case title = "title"
    case category = "category"
    case shedule = "shedule"
    case spacer = "spacer"
}

struct MainCVCellParams {
    let id: CellID
    let cellHeight: CGFloat
    let title: String
    var value: String? = nil
}

final class NewTrackerCreationVC: UIViewController {
    
    private var mainCVCells: [MainCVCellParams] = []
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    
    var newTrackerType: TrackerType
    weak var delegate: NewTrackerTypeChoiceVC?
    var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    init(newTrackerType: TrackerType, delegate: NewTrackerTypeChoiceVC? = nil) {
        self.newTrackerType = newTrackerType
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCommonUIElements(for : newTrackerType)
        
        configureMainCV(for: newTrackerType)
    }
    
    private func configureCommonUIElements(for tracker: TrackerType) {
        view.backgroundColor = .trWhite
        setTitle(for: newTrackerType)
        setButtons()
    }
    
    private func configureMainCV(for tracker: TrackerType) {
        self.mainCVCells.append(MainCVCellParams(id: .title, cellHeight: 75, title: "Введите название трекера"))
        self.mainCVCells.append(MainCVCellParams(id: .spacer, cellHeight: 24, title: ""))
        self.mainCVCells.append(MainCVCellParams(id: .category, cellHeight: 75, title: "Категория", value: "Спорт"))
        if tracker == .habit {
            self.mainCVCells.append(MainCVCellParams(id: .shedule, cellHeight: 75, title: "Расписание", value: "Пн, Чт, Вс"))
        }
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        mainCollectionView.backgroundColor = .none //.trSearchFieldBackgroundAlpha12 //.trWhite
        
        mainCollectionView.register(NTCButtonsCollectionCell.self, forCellWithReuseIdentifier: CellID.title.rawValue)
        mainCollectionView.register(NTCButtonsCollectionCell.self, forCellWithReuseIdentifier: CellID.spacer.rawValue)
        mainCollectionView.register(NTCButtonsCollectionCell.self, forCellWithReuseIdentifier: CellID.category.rawValue)
        if newTrackerType == .habit {
            mainCollectionView.register(NTCButtonsCollectionCell.self, forCellWithReuseIdentifier: CellID.shedule.rawValue)
        }
        
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainCollectionView)
        
        NSLayoutConstraint.activate([
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 87),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func setButtons() {
        let cancelButton = UIButton()
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.backgroundColor = .trWhite
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        cancelButton.setTitleColor(.trCancelButtonText, for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.trCancelButtonText.cgColor
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 16
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        self.cancelButton = cancelButton
        
        let createButton = UIButton()
        createButton.addTarget(self, action: #selector(createButtonPressed), for: .touchUpInside)
        createButton.backgroundColor = .trTabBarUpperlineAlpha30 // .trNewTrackerTitleInputCancelButton
        createButton.setTitle("Создать", for: .normal)
        createButton.titleLabel?.font = UIFont(name: SFPro.semibold, size: 16)
        createButton.setTitleColor(.trWhite, for: .normal)
        createButton.layer.masksToBounds = true
        createButton.layer.cornerRadius = 16
        createButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(createButton)
        //        createButton.isEnabled = false
        self.createButton = createButton
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            createButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor),
            createButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor, constant: 0),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func cancelButtonPressed() {
        print("CONSOLE: cancelButtonPressed" )
    }
    
    @objc private func createButtonPressed() {
        print("CONSOLE: createButtonPressed" )
    }
    @objc private func setCategoryButtonPressed() {
        //            categoryCollectionView.reloadSections(IndexSet(integer: 0))
        //            categoryCollectionView.reloadData()
        //            categoryCollectionView.setContentInsets()
        print("CONSOLE: setCategoryButtonPressed" )
    }
    
    @objc private func setScheduleButtonPressed() {
        print("CONSOLE: setScheduleButtonPressed" )
    }
}

extension NewTrackerCreationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        mainCVCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mainCVCells[indexPath.row].id.rawValue, for: indexPath) as? NTCButtonsCollectionCell {
            cell.configure(new: mainCVCells[indexPath.row], for: newTrackerType)
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

extension NewTrackerCreationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = mainCVCells[indexPath.row].cellHeight
        return CGSize(width: collectionView.bounds.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension NewTrackerCreationVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NTCButtonsCollectionCell
        //        cell?.backgroundColor = .trSearchFieldBackgroundAlpha12
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NTCButtonsCollectionCell
        //        cell?.backgroundColor = .trNewTrackerTitleBGAlpha30
    }
}
