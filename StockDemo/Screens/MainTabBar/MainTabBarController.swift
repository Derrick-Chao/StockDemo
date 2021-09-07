//
//  MainTabBarController.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import UIKit

class MainTabBarController: UITabBarController {
    // MARK:- Outlets
    
    // MARK:- Public property
    
    // MARK:- Private property
    private let viewModel = MainTabBarViewModel()
    private var stockMarketListViewController: StockMarketListViewController!
    private var customStockListViewController: CustomStockListViewController!
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        viewModel.fetchStocks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let stockMarket):
                self.stockMarketListViewController.setStockMarketData(stockMarket)
                self.customStockListViewController.setStockMarket(stockMarket)
            case .failure(let error):
                print("fetchStocks error: \(error.localizedDescription)")
                self.showError()
            }
        }
    }
    
    // MARK:- Layouts
    private func initView() {
        
        guard let viewControllers = self.viewControllers else { return }
        stockMarketListViewController = viewControllers[0] as? StockMarketListViewController
        customStockListViewController = viewControllers[1] as? CustomStockListViewController
    }
    
    // MARK:- Public methods
    
    // MARK:- Private methods
    private func showError() {
        
        let alertController = UIAlertController(title: nil, message: "無法取得股市資料，稍後再試", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK:- Actions

}
