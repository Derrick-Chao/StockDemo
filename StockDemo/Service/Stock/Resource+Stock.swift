//
//  Resource+Stock.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

extension Resource {
    
    static func allStocks() -> Resource<StockMarket> {
        
        let url = URL(string: "https://www.twse.com.tw/exchangeReport/STOCK_DAY_ALL?response=open_data")!
        let parameter: ResourceParameter = [:]
        return Resource<StockMarket>(url: url, parameters: parameter, httpMethod: .get)
    }
}
