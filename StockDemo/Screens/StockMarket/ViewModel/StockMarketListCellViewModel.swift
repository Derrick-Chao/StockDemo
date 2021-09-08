//
//  StockMarketListCellViewModel.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

class StockMarketListCellViewModel {
    // MARK:- Public property
    let id: String
    let name: String
    var isSelected: Bool
    
    // MARK:- Initialization
    init(id: String, name: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
    
    // MARK:- Public methods
    
    // MARK:- Private methods
    
}

struct StockMarketListCellViewModelBuilder {
    static func buildViewModel(stockItems: [StockItem]) -> [StockMarketListCellViewModel] {
        
        let viewModels = stockItems.map { item -> StockMarketListCellViewModel in
            
            let isSelected = CustomDataService.defaultSevice.getAllSavedStockItemIds().contains(item.id)
            return StockMarketListCellViewModel(id: item.id, name: item.name, isSelected: isSelected)
        }
        return viewModels
    }
}
