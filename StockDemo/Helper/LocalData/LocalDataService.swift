//
//  LocalDataService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

protocol LocalDataService: AnyObject {
    var userDefaults: UserDefaults { get }
}

