//
//  CustomStockListViewController.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import UIKit

class CustomStockListViewController: UIViewController, MultiTableViewDataSource {
    // MARK:- Outlets
    
    // MARK:- Public property
    
    // MARK:- Private property
    private let viewModel = CustomStockListViewModel()
    private lazy var multiTableView: MultiTableView = {
        let tableView = MultiTableView(frame: self.view.bounds)
        return tableView
    }()
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView()
        viewModel.updateClosure = { [weak self] in
            guard let self = self else { return }
            
            print("updateClosure")
            self.multiTableView.reloadData()
        }
    }
    
    // MARK:- Layouts
    private func initView() {
        
        view.addSubview(multiTableView)
        multiTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            multiTableView.topAnchor.constraint(equalTo: view.topAnchor),
            multiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            multiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            multiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        multiTableView.dataSource = self
        multiTableView.rightColumnWidth = 90.0
        multiTableView.reloadData()
    }
    
    // MARK:- Public methods
    func setStockMarket(_ stockMarket: StockMarket) {
        viewModel.setStockMarket(stockMarket)
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
    
    // MARK:- MultiTableViewDataSource
    func numberOfRows(in multiTableView: MultiTableView) -> Int {
        return viewModel.cellViewModels.count
    }

    func multiTableView(_ tableView: UITableView, type: TableViewType, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        switch type {
        case .left:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftTableViewCell", for: indexPath) as! LeftTableViewCell
            cell.titleLabel.text = cellViewModel.stockName
            return cell
        case .right:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as! RightTableViewCell
            cell.bindToData(viewModel: cellViewModel)
            cell.timer = viewModel.priceUpdateService.createTimer(index: indexPath.row, completion: { [weak self, tableView] index, priceResult in
                guard let self = self else { return }
                
                let newCellViewModel = self.viewModel.cellViewModels[indexPath.row]
                newCellViewModel.updateValue(priceResult)
//                print("createTimer completion: \(index), \(priceResult)")
                if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? RightTableViewCell {
                    
//                    cell.showUpdate(backgroundColor: priceResult.displayColor)
                    cell.bindToData(viewModel: newCellViewModel)
                }
            })
            return cell
        }
    }
    
    func multiTableViewForTopLeftTitleView(_ multiTableView: MultiTableView) -> UIView? {
        
        let label = UILabel()
        label.textAlignment = .center
        label.text = "商品"
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .gray
        return label
    }
    
    func multiTableViewRowHeight(_ multiTableView: MultiTableView) -> CGFloat {
        return 75.0
    }
    
    func multiTableViewTopTitles(_ multiTableView: MultiTableView) -> [String] {
        return ["成交", "漲跌", "幅度", "時間"]
    }
}
