//
//  CustomStockListCellViewModel.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import Foundation
import UIKit

class CustomStockListCellViewModel {
    // MARK:- Public property
    let stockId: String
    let stockName: String
    var closingPrice: String
    var changePrice: String
    var changeRate: String
    var updateTime: String
    var displayColor: UIColor = .white
    
    // MARK:- Private property
    
    // MARK:- Initialization
    init(stockId: String, stockName: String, closingPrice: String, changePrice: String, changeRate: String, updateTime: String) {
        self.stockId = stockId
        self.stockName = stockName
        self.closingPrice = closingPrice
        self.changePrice = changePrice
        self.changeRate = changeRate
        self.updateTime = updateTime
    }
    
    // MARK:- Public methods
    func updateValue(_ newValue: PriceResult) {
        
        closingPrice = newValue.newPrice
        changePrice = newValue.changePrice
        changeRate = newValue.changeRate
        updateTime = newValue.updateTime
        displayColor = newValue.displayColor
    }
    
    // MARK:- Private methods
}

struct CustomStockListCellViewModelBuilder {
    static func buildViewModels(items: [StockItem]) -> [CustomStockListCellViewModel] {
        
        let viewModels = items.map { stockItem -> CustomStockListCellViewModel in
            CustomStockListCellViewModelBuilder.buildViewModel(stockItem: stockItem)
        }
        return viewModels
    }
    
    static func buildViewModel(stockItem: StockItem) -> CustomStockListCellViewModel {
        
        let viewModel = CustomStockListCellViewModel(stockId: stockItem.id, stockName: stockItem.name, closingPrice: stockItem.closingPrice, changePrice: "0.0", changeRate: "0.0%", updateTime: Date().getCurrentDateString(format: "hh:mm:ss"))
        return viewModel
    }
}
