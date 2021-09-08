//
//  StockMarketListViewModel.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

enum StockMarketListError: Error {
    case objectDeallocated
}

enum StockMarketListState {
    case success
    case failure(Error)
}

class StockMarketListViewModel {
    // MARK:- Public property
    var cellViewModels: [StockMarketListCellViewModel] = []
    
    var updateClosure: (() -> ())?
    
    // MARK:- Private property
    private let stockService = StockService()
    private let customDataService = CustomDataService.defaultSevice
    private var stockMarket: StockMarket?
    private var allStockItems: [StockItem] = []
    private var isSelectedAll = false
    
    // MARK:- Initialization
    init() {
        
    }
    
    // MARK:- Public methods
    func setStockMarket(_ stockMarket: StockMarket) {
        
        self.stockMarket = stockMarket
        self.allStockItems = stockMarket.stockItems
        buildViewModels(stockMarket.stockItems)
        updateClosure?()
    }
    
    func getStockItem(index: Int) -> StockItem? {
        guard let stockMarket = self.stockMarket else { return nil }
        
        return stockMarket.stockItems[index]
    }
    
    func selectAllItems() {
        guard !isSelectedAll else { return }
        
        isSelectedAll = true
        for cellViewModel in cellViewModels {
            cellViewModel.isSelected = true
        }
        
        var newStockIds = allStockItems.map { $0.id }
        let savedIds = customDataService.getAllSavedStockItemIds()
        print("newStockIds count: \(newStockIds.count), savedIds: \(savedIds.count)")
        if !savedIds.isEmpty {
            
            for stockId in savedIds {
                if let index = newStockIds.firstIndex(of: stockId) {
                    newStockIds.remove(at: index)
                }
            }
        }
        print("newStockIds count: \(newStockIds.count)")
        customDataService.saveMultipleStockItems(ids: newStockIds)
        updateClosure?()
    }
    
    func deselectAllItems() {
        
        isSelectedAll = false
        for cellViewModel in cellViewModels {
            cellViewModel.isSelected = false
        }
        customDataService.removeAllStockItemIds()
        updateClosure?()
    }
    
    func toggleStockItemSaveState(index: Int) -> StockMarketListCellViewModel {
        
        let cellViewModel = cellViewModels[index]
        cellViewModel.isSelected = !cellViewModel.isSelected
        if cellViewModel.isSelected {
            customDataService.saveSelectedStockItem(id: cellViewModel.id)
        } else {
            customDataService.removeStockItem(id: cellViewModel.id)
        }
        return cellViewModel
    }
    
    // MARK:- Private methods
    private func buildViewModels(_ items: [StockItem]) {
        
        let cellViewModels = StockMarketListCellViewModelBuilder.buildViewModel(stockItems: items)
        let savedCount = cellViewModels.filter { $0.isSelected == true }.count
        isSelectedAll = (savedCount == items.count)
        self.cellViewModels = cellViewModels
    }
}
