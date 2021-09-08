//
//  CustomDataService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

protocol CustomDataServiceProtocol {
    /// 修改預設的更新資料時間(單位為 second)
    func savePriceUpdateInterval(interval: Double)
    /// 取得現在的更新資料時間(單位為 second)
    func getPriceUpdateInterval() -> Double
    /// 執行單一商品儲存至自選清單
    func saveSelectedStockItem(id: String)
    /// 執行單一商品從自選清單移除
    func removeStockItem(id: String)
    /// 取得現有儲存的自選清單
    func getAllSavedStockItemIds() -> [String]
    /// 新增多筆商品至自選清單
    func saveMultipleStockItems(ids: [String])
    /// 移除所有自選清單
    func removeAllStockItemIds()
}

class CustomDataService: LocalDataService, CustomDataServiceProtocol {
    // MARK:- Public property
    static let defaultSevice = CustomDataService()
    
    let userDefaults: UserDefaults
    ///單一商品新增移除時的callback, isSaved true: 新增 false: 移除
    var singleItemDidChangeClosure: ((_ isSaved: Bool, _ id: String) -> ())?
    /// 多樣商品新增移除時的callback, isSaved true: 新增 false: 移除
    var batchOfItemsDidChangeClosure: ((_ isSaved: Bool, _ ids: [String]) -> ())?
    
    // MARK:- Private property
    private let firstOpenKey = "FirstOpen"
    private let allItemKey = "AllItem"
    private let priceUpdateIntervalKey = "PriceUpdateInterval"
    /// 預設自選股票清單id，在使用者第一次使用時賦予
    private let defaultStockIds: [String] = ["2609", "2603", "3481", "00715L", "2303", "2610", "2353", "2317", "3576", "2883", "00632R", "2409", "2888", "2344", "2457", "2890", "00637L", "2489", "2337", "2356", "2330", "2882", "00642U", "2891", "6116", "3704", "2618", "2601", "3231", "3094", "00881", "2881", "2641", "8054", "2324", "4961", "6443", "2884" , "2338", "2886", "2002", "2363", "2014", "2892", "2331", "5608", "2605", "3037", "1314", "8150", "1568", "2402", "2617", "2371", "2328", "4956", "2885", "2340", "3711", "6147", "3058", "5880", "6283", "1301", "2887", "2106", "8936", "2357", "8358", "6244", "3707", "4960", "1101", "5285", "3346", "4938", "8183", "8069"]
    private var savedItemIds: [String] = []
    private var priceUpdateTimeInterval: TimeInterval = 0
    
    // MARK:- Initialization
    private init(userDefaults: UserDefaults = .standard) {
        
        self.userDefaults = userDefaults
        self.initialPriceUpdateTime()
        self.parsingSaveItemIds()
    }
    
    // MARK:- Public methods
    func savePriceUpdateInterval(interval: Double) {
        
        userDefaults.set(interval, forKey: priceUpdateIntervalKey)
        userDefaults.synchronize()
    }
    
    func getPriceUpdateInterval() -> Double {
        userDefaults.double(forKey: priceUpdateIntervalKey)
    }
    
    func saveSelectedStockItem(id: String) {
        
        savedItemIds.append(id)
        let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
        userDefaults.set(idsData, forKey: allItemKey)
        userDefaults.synchronize()
        singleItemDidChangeClosure?(true, id)
    }
    
    func removeStockItem(id: String) {
        
        if let index = savedItemIds.firstIndex(of: id) {
            savedItemIds.remove(at: index)
        }

        let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
        userDefaults.set(idsData, forKey: allItemKey)
        userDefaults.synchronize()
//        print("removeStockItem: \(savedItemIds)")
        singleItemDidChangeClosure?(false, id)
    }
    
    func getAllSavedStockItemIds() -> [String] {
        return savedItemIds
    }
    
    func saveMultipleStockItems(ids: [String]) {
        
        savedItemIds.append(contentsOf: ids)
        let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
        userDefaults.set(idsData, forKey: allItemKey)
        userDefaults.synchronize()
        batchOfItemsDidChangeClosure?(true, ids)
    }
    
    func removeAllStockItemIds() {
        
        savedItemIds.removeAll()
        userDefaults.removeObject(forKey: allItemKey)
        userDefaults.synchronize()
        batchOfItemsDidChangeClosure?(false, [])
    }
    
    // MARK:- Private methods
    private func parsingSaveItemIds() {
        
        let isFirstOpen = userDefaults.object(forKey: firstOpenKey)
        if isFirstOpen == nil {
            // 如果是第一次開啟，先給予預設的清單
            savedItemIds = defaultStockIds
            let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
            userDefaults.set(idsData, forKey: allItemKey)
            userDefaults.set(true, forKey: firstOpenKey)
            userDefaults.synchronize()
        } else if let idsData = userDefaults.object(forKey: allItemKey) as? Data, let items = NSKeyedUnarchiver.unarchiveObject(with: idsData) as? [String] {
            self.savedItemIds = items
        }
    }
    
    private func initialPriceUpdateTime() {
        
        priceUpdateTimeInterval = userDefaults.double(forKey: priceUpdateIntervalKey)
        if priceUpdateTimeInterval == 0.0 {
            
            priceUpdateTimeInterval = 0.6
            savePriceUpdateInterval(interval: 0.6)
        }
    }
}
