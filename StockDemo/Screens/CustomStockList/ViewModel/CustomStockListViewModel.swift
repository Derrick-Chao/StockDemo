//
//  CustomStockListViewModel.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import Foundation

class CustomStockListViewModel {
    // MARK:- Public property
    let priceUpdateService = PriceUpdateService.defaultService
    var updateClosure: (() -> ())?
    var cellViewModels: [CustomStockListCellViewModel] = []
    
    // MARK:- Private property
    private let customDataService = CustomDataService.defaultSevice
    private var stockMarket: StockMarket?
    private var saveStockItems: [StockItem] = []
    
    // MARK:- Initialization
    init() {
        
        priceUpdateService.updateClosure = { [weak self] in
            guard let self = self else { return }
            
            self.updateClosure?()
        }
        
        customDataService.itemStateDidChangeClosure = { [weak self] isSaved, stockId in
            guard let self = self else { return }
            /*
             在股票清單Tab頁面，有發生 新增/移除 商品的動作時
             在這邊做處理來單一新增或移除使用者所選擇的商品資料
             */
            if isSaved, let stockItems = self.stockMarket?.stockItems {
                
                if let stockItem = stockItems.first(where: { $0.id == stockId }) {
                    
                    self.saveStockItems.append(stockItem)
                    let cellViewModel = self.buildViewModel(stockItem: stockItem)
                    self.cellViewModels.append(cellViewModel)
                }
            } else {
                
                if let index = self.saveStockItems.firstIndex(where: { $0.id == stockId }) {
                    
                    self.saveStockItems.remove(at: index)
                    self.cellViewModels.remove(at: index)
                }
            }
            // 也須更新 PriceUpdateService 的資料
            self.priceUpdateService.updateStockItems(self.saveStockItems)
        }
    }
    
    // MARK:- Public methods
    /// 初始設定股票市場資料
    func setStockMarket(_ stockMarket: StockMarket) {
        
        self.stockMarket = stockMarket
        parsingSavedStockItems(items: stockMarket.stockItems)
        priceUpdateService.updateStockItems(saveStockItems)
        cellViewModels = buildViewModels(items: saveStockItems)
        updateClosure?()
    }
    
    // MARK:- Private methods
    /*
     過濾出使用者自選的清單資料來顯示
     */
    private func parsingSavedStockItems(items: [StockItem]) {
        
        saveStockItems.removeAll()
        let savedItemIds = customDataService.getAllSavedStockItemIds()
        for id in savedItemIds {
            
            if let item = items.filter( { $0.id == id} ).first {
                saveStockItems.append(item)
            }
        }
    }
    
    // MARK: Build ViewModels
    private func buildViewModel(stockItem: StockItem) -> CustomStockListCellViewModel {
        CustomStockListCellViewModelBuilder.buildViewModel(stockItem: stockItem)
    }
    
    private func buildViewModels(items: [StockItem]) -> [CustomStockListCellViewModel] {
        CustomStockListCellViewModelBuilder.buildViewModels(items: items)
    }
}
