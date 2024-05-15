//
//  NewTrackerCreationVC.swift
//  Tracker
//
//  Created by Andrey Zhelev on 12.05.2024.
//

import UIKit

enum TrackerType: String {
    case habit
    case event
}

final class NewTrackerCreationVC: UIViewController {
    
    let newTrackerType: TrackerType
    var categoryButtonsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    weak var delegate: NewTrackerTypeChoiceVC?
    
    private var inputCancelButton = UIButton()
    private var newTrackerTitleView = UIView()
//    private var newTrackerAddCategoryButtonBGView = UIView()
    private var newTrackerAddCategoryButton = UIButton()
    private var newTrackerAddScheduleButton = UIButton()
    private var cancelButton = UIButton()
    private var createButton = UIButton()
    private var categoryButtonsCollectionViewCellsCount = 1
    private let minimumLineSpacing: CGFloat = 0
    private var newTracker = Tracker(id: UUID(),
                                     name: "",
                                     color: nil,
                                     emoji: nil,
                                     schedule: [false, false, false, false, false, false, false
                                               ])
    private var newTrackerCategory: String? = "Тестовое название категории"
    
    
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
        
        view.backgroundColor = .trWhite
        
        configureUIElements(for : newTrackerType)
        
    }
    
    private func configureUIElements(for tracker : TrackerType) {
        setTitle(for: tracker)
        setCategoryButtonsCollectionView(for: tracker)
        setCategoryButton(for: tracker)
        
        if tracker == .habit {
            setScheduleButton()
        }
        setBottomButtons()
    }
    
    private func setCategoryButtonsCollectionView(for tracker : TrackerType) {
        categoryButtonsCollectionView.dataSource = self
        categoryButtonsCollectionView.delegate = self
        categoryButtonsCollectionView.register(NTCButtonsCollectionCell.self, forCellWithReuseIdentifier: "cell")
        categoryButtonsCollectionView.backgroundColor = .trNewTrackerTitleBGAlpha30 //.none
        
        categoryButtonsCollectionView.layer.masksToBounds = true
        categoryButtonsCollectionView.layer.cornerRadius = 16
        if tracker == .habit {
            categoryButtonsCollectionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        categoryButtonsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryButtonsCollectionView)

        NSLayoutConstraint.activate([
            categoryButtonsCollectionView.heightAnchor.constraint(equalToConstant: 75),
            categoryButtonsCollectionView.topAnchor.constraint(equalTo: newTrackerTitleView.bottomAnchor, constant: 24),
            categoryButtonsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryButtonsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setCollectionViewContentPosition(for cellHeight: CGFloat) {
        let inset = max((categoryButtonsCollectionView.frame.height - cellHeight * CGFloat(categoryButtonsCollectionViewCellsCount)) / 2 - minimumLineSpacing, 0)
        categoryButtonsCollectionView.contentInset.top = inset
        categoryButtonsCollectionView.contentInset.left = 16
        categoryButtonsCollectionView.contentInset.right = 50
    }
    
    private func setTitle(for tracker : TrackerType) {
        let titleLabel = UILabel()
        titleLabel.text = tracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        titleLabel.font = UIFont(name: SFPro.semibold, size: 16)
        titleLabel.textColor = .trBlack
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let newTrackerTitleView = UIView()
        newTrackerTitleView.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerTitleView.layer.masksToBounds = true
        newTrackerTitleView.layer.cornerRadius = 16
        newTrackerTitleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerTitleView)
        self.newTrackerTitleView = newTrackerTitleView
        
        let titleTextField = UITextField()
        titleTextField.placeholder = "Введите название трекера"
        titleTextField.clearButtonMode = .always
        titleTextField.textColor = .trBlack
        titleTextField.font = UIFont(name: SFPro.regular, size: 17)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        newTrackerTitleView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            
            newTrackerTitleView.heightAnchor.constraint(equalToConstant: 75),
            newTrackerTitleView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            newTrackerTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerTitleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            titleTextField.centerYAnchor.constraint(equalTo: newTrackerTitleView.centerYAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: newTrackerTitleView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: newTrackerTitleView.trailingAnchor, constant: -16)
        ])
        
    }
    
    private func setCategoryButton(for tracker: TrackerType) {
        
        let newTrackerAddCategoryButton = UIButton()
        newTrackerAddCategoryButton.addTarget(self, action: #selector(setCategoryButtonPressed), for: .touchUpInside)
        newTrackerAddCategoryButton.backgroundColor = .none // .trNewTrackerTitleBGAlpha30
        newTrackerAddCategoryButton.layer.masksToBounds = true
        newTrackerAddCategoryButton.layer.cornerRadius = 16
        newTrackerAddCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerAddCategoryButton)
        self.newTrackerAddCategoryButton = newTrackerAddCategoryButton
        
        if tracker == .habit {
            newTrackerAddCategoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        NSLayoutConstraint.activate([
            newTrackerAddCategoryButton.heightAnchor.constraint(equalTo: categoryButtonsCollectionView.heightAnchor),
            newTrackerAddCategoryButton.topAnchor.constraint(equalTo: categoryButtonsCollectionView.topAnchor),
            newTrackerAddCategoryButton.leadingAnchor.constraint(equalTo: categoryButtonsCollectionView.leadingAnchor),
            newTrackerAddCategoryButton.trailingAnchor.constraint(equalTo: categoryButtonsCollectionView.trailingAnchor)
        ])
        addChevronOnButton(on: newTrackerAddCategoryButton)
    }
    
    private func setScheduleButton() {
        let newTrackerAddScheduleButton = UIButton()
        newTrackerAddScheduleButton.addTarget(self, action: #selector(setScheduleButtonPressed), for: .touchUpInside)
        newTrackerAddScheduleButton.backgroundColor = .trNewTrackerTitleBGAlpha30
        newTrackerAddScheduleButton.layer.masksToBounds = true
        newTrackerAddScheduleButton.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        newTrackerAddScheduleButton.layer.cornerRadius = 16
        newTrackerAddScheduleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newTrackerAddScheduleButton)
        self.newTrackerAddScheduleButton = newTrackerAddScheduleButton
        
        let buttonDivider = UIView()
        buttonDivider.backgroundColor = .trTabBarUpperlineAlpha30
        buttonDivider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonDivider)
        
        NSLayoutConstraint.activate([
            newTrackerAddScheduleButton.heightAnchor.constraint(equalToConstant: 75),
            newTrackerAddScheduleButton.topAnchor.constraint(equalTo: newTrackerAddCategoryButton.bottomAnchor, constant: 0),
            newTrackerAddScheduleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            newTrackerAddScheduleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonDivider.heightAnchor.constraint(equalToConstant: 0.5),
            buttonDivider.centerYAnchor.constraint(equalTo: newTrackerAddScheduleButton.topAnchor, constant: 0),
            buttonDivider.leadingAnchor.constraint(equalTo: newTrackerAddScheduleButton.leadingAnchor, constant: 16),
            buttonDivider.trailingAnchor.constraint(equalTo: newTrackerAddScheduleButton.trailingAnchor, constant: -16)
        ])
        addChevronOnButton(on: newTrackerAddScheduleButton)
    }
    
    private func addChevronOnButton(on buttonView: UIView) {
        let chevron = UIImageView(image: UIImage(named: "chevron"))
        chevron.tintColor = .trNewTrackerTitleInputCancelButton
        chevron.translatesAutoresizingMaskIntoConstraints = false
        buttonView.addSubview(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor, constant: -33)
        ])
        
    }
    
    private func setBottomButtons() {
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
    
    @objc private func setCategoryButtonPressed() {
        newTrackerAddCategoryButton.backgroundColor = .trSearchFieldBackgroundAlpha12
        categoryButtonsCollectionViewCellsCount += 1
        categoryButtonsCollectionView.reloadData()
        print("CONSOLE: setCategoryButtonPressed" )
    }
    
    @objc private func setScheduleButtonPressed() {
        print("CONSOLE: setScheduleButtonPressed" )
    }
    
    @objc private func cancelButtonPressed() {
        print("CONSOLE: cancelButtonPressed" )
    }
    
    @objc private func createButtonPressed() {
        print("CONSOLE: createButtonPressed" )
    }
    
    @objc private func textInputCancel() {
        print("CONSOLE: " )
        newTrackerAddCategoryButton.backgroundColor = .gray
    }
}

extension NewTrackerCreationVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryButtonsCollectionViewCellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NTCButtonsCollectionCell {
            
            if indexPath.row == 0 {
                cell.setupLabel(for: CellType.title, with: "Категория")
            } else {
                cell.setupLabel(for: CellType.value, with: newTrackerCategory ?? "")
            }
            
            return cell
        }
        fatalError("Проблема с подготовкой ячейки")
    }
}

extension NewTrackerCreationVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellHeight = collectionView.bounds.height/4
        let cellHeight = (46 - minimumLineSpacing) / 2
        setCollectionViewContentPosition(for: cellHeight)
        return CGSize(width: collectionView.bounds.width - 66, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        minimumLineSpacing
    }
}

