//
//  PriceUpdateService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import Foundation
import UIKit

typealias PriceResult = (newPrice: String, changePrice: String, changeRate: String, updateTime: String, displayColor: UIColor)

class PriceUpdateService {
    // MARK:- Public property
    static let defaultService = PriceUpdateService()
    var updateInterval: TimeInterval = CustomDataService.defaultSevice.getPriceUpdateInterval() {
        didSet {
          
            CustomDataService.defaultSevice.savePriceUpdateInterval(interval: updateInterval)
            for timer in timeDict.values {
                timer.invalidate()
            }
            timeDict.removeAll()
            DispatchQueue.main.async {
                self.updateClosure?()
            }
        }
    }
    var updateClosure: (() -> ())?
    
    // MARK:- Private property
    private var stockItems: [StockItem] = []
    private var timeDict: [Int: Timer] = [:]
    private var referencePrices: [String] = []
    
    // MARK:- Initialization
    init() {
        
    }
    
    // MARK:- Public methods
    func updateStockItems(_ stockItems: [StockItem]) {
        
        self.stockItems = stockItems
        for timer in timeDict.values {
            timer.invalidate()
        }
        timeDict.removeAll()
        
        referencePrices.removeAll()
        for stockItem in stockItems {
            referencePrices.append(stockItem.closingPrice)
        }
//        print("referencePrices: \(referencePrices.count)")
        updateClosure?()
    }
    
    func createTimer(index: Int, completion: @escaping (_ index: Int, _ result: PriceResult) -> ()) -> Timer {
        
        let timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self, index] timer in
            guard let self = self else { return }
            
            let priceResult = self.updatePrice(index)
            completion(index, priceResult)
        }
        let randomDelay = Double.random(in: 0.0...0.35)
        timer.fireDate = Date(timeIntervalSinceNow: randomDelay)
        timeDict[index] = timer
        RunLoop.current.add(timer, forMode: .common)
        return timer
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
    private func updatePrice(_ index: Int) -> PriceResult {
     
        let closingPrice = referencePrices[index]
        guard let closingPriceValue = Double(closingPrice) else { return ("", "", "", "", .white) }
        
        let randomRate = Int.random(in: -10...10)
        var newPriceValue = 0.0
        var changePriceValue = 0.0
        if closingPriceValue < 10.0 {
            
            changePriceValue = (0.01 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        } else if closingPriceValue >= 10.0 && closingPriceValue < 50.0 {
            
            changePriceValue = (0.05 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        } else if closingPriceValue >= 50.0 && closingPriceValue < 100 {
            
            changePriceValue = (0.1 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        } else if closingPriceValue >= 100.0 && closingPriceValue < 500.0 {
            
            changePriceValue = (0.5 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        } else if closingPriceValue >= 500.0 && closingPriceValue < 1000.0 {
            
            changePriceValue = (1.0 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        } else { // >= 1000.0
            
            changePriceValue = (5.0 * Double(randomRate))
            newPriceValue = closingPriceValue + changePriceValue
        }
//        print("index: \(index), closingPrice: \(closingPriceValue), newPriceValue: \(newPriceValue)")
        let newPrice = String(format: "%.2f", newPriceValue)
        let changePrice = String(format: "%.2f", changePriceValue)
        let changeRateValue = changePriceValue / closingPriceValue
        let changeRate = String(format: "%.2f%%", changeRateValue * 100.0)
        let updateTime = Date().getCurrentDateString(format: "hh:mm:ss")
        
        var color: UIColor = .white
        if newPriceValue == closingPriceValue {
            color = .white
        } else if newPriceValue > closingPriceValue {
            color = .red
        } else if newPriceValue < closingPriceValue {
            color = .green
        }
        return (newPrice, changePrice, changeRate, updateTime, color)
    }
}
