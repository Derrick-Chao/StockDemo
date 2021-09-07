//
//  CustomDataService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

protocol CustomDataServiceProtocol {
    /// 單位為 second
    func savePriceUpdateInterval(interval: Double)
    func getPriceUpdateInterval() -> Double
    func saveSelectedStockItem(id: String)
    func removeStockItem(id: String)
    func getAllSavedStockItemIds() -> [String]
}

class CustomDataService: LocalDataService, CustomDataServiceProtocol {
    // MARK:- Public property
    static let defaultSevice = CustomDataService()
    
    let userDefaults: UserDefaults
    var itemStateDidChangeClosure: ((_ isSaved: Bool, _ id: String) -> ())?
    
    // MARK:- Private property
    private let allItemKey = "AllItem"
    private let priceUpdateIntervalKey = "PriceUpdateInterval"
    private var savedItemIds: [String] = []
    private var priceUpdateTimeInterval: TimeInterval = 0
    /// 預設自選股票清單id，在使用者第一次使用時賦予
    private let defaultStockIds: [String] = ["2609", "2603", "3481", "00715L", "2303", "2610", "2353", "2317", "3576", "2883", "00632R", "2409", "2888", "2344", "2457", "2890", "00637L", "2489", "2337", "2356", "2330", "2882", "00642U", "2891", "6116", "3704", "2618", "2601", "3231", "3094", "00881", "2881", "2641", "8054", "2324", "4961", "6443", "2884" , "2338", "2886", "2002", "2363", "2014", "2892", "2331", "5608", "2605", "3037", "1314", "8150", "1568", "2402", "2617", "2371", "2328", "4956", "2885", "2340", "3711", "6147", "3058", "5880", "6283", "1301", "2887", "2106", "8936", "2357", "8358", "6244", "3707", "4960", "1101", "5285", "3346", "4938", "8183", "8069"]
    
    // MARK:- Initialization
    private init(userDefaults: UserDefaults = .standard) {
        
        self.userDefaults = userDefaults
        if let idsData = userDefaults.object(forKey: allItemKey) as? Data, let items = NSKeyedUnarchiver.unarchiveObject(with: idsData) as? [String] {
            self.savedItemIds = items
        } else {
            
            savedItemIds = defaultStockIds
            let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
            userDefaults.set(idsData, forKey: allItemKey)
            userDefaults.synchronize()
        }
//        print("init savedItemIds: \(savedItemIds)")
        priceUpdateTimeInterval = userDefaults.double(forKey: priceUpdateIntervalKey)
        if priceUpdateTimeInterval == 0.0 {
            
            priceUpdateTimeInterval = 0.6
            savePriceUpdateInterval(interval: 0.6)
        }
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
//        print("saveSelectedStockItem: \(savedItemIds)")
        let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
        userDefaults.set(idsData, forKey: allItemKey)
        userDefaults.synchronize()
        itemStateDidChangeClosure?(true, id)
    }
    
    func removeStockItem(id: String) {
        
        if let index = savedItemIds.firstIndex(of: id) {
            savedItemIds.remove(at: index)
        }

        let idsData = NSKeyedArchiver.archivedData(withRootObject: savedItemIds)
        userDefaults.set(idsData, forKey: allItemKey)
        userDefaults.synchronize()
//        print("removeStockItem: \(savedItemIds)")
        itemStateDidChangeClosure?(false, id)
    }
    
    func getAllSavedStockItemIds() -> [String] {
        return savedItemIds
    }
    
    // MARK:- Private methods
}
