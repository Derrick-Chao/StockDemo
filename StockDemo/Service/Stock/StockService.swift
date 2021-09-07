//
//  StockService.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import Foundation

class StockService: NetworkServiceProtocol {
    // MARK:- Public property
    let urlSession: URLSession
    
    // MARK:- Private property
    
    // MARK:- Initialization
    init(configuration: URLSessionConfiguration = .default) {
        self.urlSession = URLSession(configuration: configuration)
    }
    
    // MARK:- Public methods
    func fetchAllStocks(completion: @escaping (_ result: Result<StockMarket, NetworkError>) -> ()) {
        fetch(Resource<StockMarket>.allStocks()) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    // MARK:- Private methods
}
