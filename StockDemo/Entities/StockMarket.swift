//
//  StockMarket.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

struct StockMarket: Decodable {
    let title: String
    let date: String
    let fields: [String]
    let stockItems: [StockItem]
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case fields
        case stockItems = "data"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        date = try container.decode(String.self, forKey: .date)
        /*
         fields 裏面資料是代表是給 data array 中每一個item，從 index 0 開始每個欄位代表的意義
         ["證券代號", "證券名稱", "成交股數", "成交金額", "開盤價", "最高價", "最低價", "收盤價", "漲跌價差", "成交筆數"]
         e.g. item
         ["0050", "元大台灣50", "14,283,400", "2,037,715,398", "141.90", "143.50", "141.60", "142.55", "+0.65", "14,230"]
         */
        fields = try container.decode([String].self, forKey: .fields)
        let dataArray = try container.decode([[String]].self, forKey: .stockItems)
        /*
         這邊暫時只取 "證券代號", "證券名稱", "收盤價" 三個欄位資料來組成 data
         "證券代號": index 0
         "證券名稱": index 1
         "收盤價": index 7
         */
        var tempStockItems: [StockItem] = []
        for itemData in dataArray {
            // 這邊暫定欄位沒有到收盤價的 index，就不新增這筆
            if itemData.count > 7 {
                
                let stockId = itemData[0]
                let stockName = itemData[1]
                let closingPrice = itemData[7]
                let stockItem = StockItem(id: stockId, name: stockName, closingPrice: closingPrice)
                tempStockItems.append(stockItem)
            }
        }
        stockItems = tempStockItems
    }
}
