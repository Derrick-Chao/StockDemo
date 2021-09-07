//
//  StockItem.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

struct StockItem: Decodable {
    /// 證券代號
    let id: String
    /// 證券名稱
    let name: String
    /// 收盤價
    let closingPrice: String
}
