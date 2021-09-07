//
//  DateExtension.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import Foundation

extension Date {
    
    func getCurrentDateString(format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date())
    }
}
