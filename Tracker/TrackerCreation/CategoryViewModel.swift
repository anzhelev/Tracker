//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Andrey Zhelev on 10.07.2024.
//

import Foundation
protocol CategoryViewModelDelegate: AnyObject {
    func updateNewTrackerCategory(newTrackerCategory: String?)
}

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    
    // MARK: - Public Properties
    weak var delegate: CategoryViewModelDelegate?
    var categoryListDidUpdate: Binding<Bool>?
    var selectedCategoryDidUpdate: Binding<Bool>?
    
    // MARK: - Private Properties
    private let storeService: StoreService?
    private (set) var categoryList: [String] = []
    private (set) var selectedCategory: String? = nil
    private (set) var stubIsHidden: Bool = false
    
    // MARK: - Initializers
    init (delegate: CategoryViewModelDelegate, selectedCategory: String?) {
        self.delegate = delegate
        self.selectedCategory = selectedCategory
        self.storeService = StoreService(delegate: nil)
        updateCategoryList()
    }
    
    // MARK: - Public Methods
    func getCellParams(for row: Int) -> CategoryTableCellParams {
        var corners: RoundedCorners = .none
        var separator: Bool = false
        
        if self.categoryList.count == 1 {
            corners = .all
        } else if row == 0 {
            corners = .top
            separator.toggle()
        } else if row == self.categoryList.count - 1 {
            corners = .bottom
        } else {
            separator.toggle()
        }
        
        return CategoryTableCellParams(title: self.categoryList[row],
                                       corners: corners,
                                       separator: separator,
                                       isSelected: self.categoryList[row] == selectedCategory)
    }
    
    func updateSelectedCategory(with index: IndexPath) {
        self.selectedCategory = categoryList[index.row]
        self.delegate?.updateNewTrackerCategory(newTrackerCategory: self.selectedCategory)
        selectedCategoryDidUpdate?(true)
    }
    
    // MARK: - Private Methods
    private func updateCategoryList() {
        self.storeService?.fetchCategoryList()
        self.categoryList = storeService?.categoryList.sorted() ?? []
        self.stubIsHidden = categoryList.count == 0
        categoryListDidUpdate?(true)
    }
}
// MARK: - CategoryCreationVCDelegate
extension CategoryViewModel: CategoryCreationVCDelegate {
    func addNewCategory(category: String) {
        self.storeService?.addCategoriesToStore(newlist: [category])
        updateCategoryList()
    }
}
