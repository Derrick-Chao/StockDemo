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
    
    // MARK:- Initialization
    init() {
        
    }
    
    // MARK:- Public methods
    func fetchStocks(completion: @escaping (_ result: StockMarketListState) -> ()) {
        
        stockService.fetchAllStocks { [weak self] result in
            guard let self = self else {
                completion(.failure(StockMarketListError.objectDeallocated))
                return
            }
            
            switch result {
            case .success(let stockMarket):
                self.stockMarket = stockMarket
                self.buildViewModels(stockMarket.stockItems)
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setStockMarket(_ stockMarket: StockMarket) {
        
        self.stockMarket = stockMarket
        buildViewModels(stockMarket.stockItems)
        updateClosure?()
    }
    
    func getStockItem(index: Int) -> StockItem? {
        guard let stockMarket = self.stockMarket else { return nil }
        
        return stockMarket.stockItems[index]
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
        self.cellViewModels = cellViewModels
    }
}
