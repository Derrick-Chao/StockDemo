//
//  RightTableViewCell.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import UIKit

class RightTableViewCell: UITableViewCell {
    // MARK:- Outlets
    @IBOutlet weak var dealedPriceLabel: UILabel!
    @IBOutlet weak var changedPriceLabel: UILabel!
    @IBOutlet weak var changedRateLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var updateIndicatorLineView: UIView!
    
    // MARK:- Public property
    var timer: Timer?
    
    // MARK:- Private property
    
    
    // MARK:- Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        timer?.invalidate()
        timer = nil
    }
    
    // MARK:- Layouts
    private func initView() {
        
        backgroundColor = .black
        dealedPriceLabel.textColor = .white
        dealedPriceLabel.backgroundColor = .black
        changedPriceLabel.textColor = .white
        changedPriceLabel.backgroundColor = .black
        changedRateLabel.textColor = .white
        changedRateLabel.backgroundColor = .black
        updateTimeLabel.textColor = .white
        updateTimeLabel.backgroundColor = .black
        
        updateIndicatorLineView.alpha = 0.0
        updateIndicatorLineView.backgroundColor = .white
    }
    
    // MARK:- Public methods
    func bindToData(viewModel: CustomStockListCellViewModel) {
        
        dealedPriceLabel.text = viewModel.closingPrice
        dealedPriceLabel.textColor = viewModel.displayColor
        
        changedPriceLabel.textColor = viewModel.displayColor
        changedPriceLabel.text = viewModel.changePrice
        
        changedRateLabel.textColor = viewModel.displayColor
        changedRateLabel.text = viewModel.changeRate
        
        updateTimeLabel.textColor = viewModel.displayColor
        updateTimeLabel.text = viewModel.updateTime
    }
    
    func showUpdate(backgroundColor: UIColor) {
        
        updateIndicatorLineView.backgroundColor = backgroundColor
        UIView.animate(withDuration: 0.3) {
            self.updateIndicatorLineView.alpha = 1.0
        } completion: { _ in
            self.updateIndicatorLineView.alpha = 0.0
        }
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
}
