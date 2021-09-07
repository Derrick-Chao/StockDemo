//
//  MainTabBarViewModel.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import Foundation

class MainTabBarViewModel {
    // MARK:- Public property
    
    // MARK:- Private property
    private let stockService = StockService()
    
    // MARK:- Initialization
    init() {
        
    }
    
    // MARK:- Public methods
    func fetchStocks(completion: @escaping (_ result: Result<StockMarket, Error>) -> ()) {
        
        stockService.fetchAllStocks { [weak self] result in
            guard let _ = self else {
                completion(.failure(StockMarketListError.objectDeallocated))
                return
            }
            
            switch result {
            case .success(let stockMarket):
                completion(.success(stockMarket))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK:- Private methods
    
}
