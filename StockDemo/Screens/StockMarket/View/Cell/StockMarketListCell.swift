//
//  StockMarketListCell.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import UIKit

class StockMarketListCell: UITableViewCell {
    // MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK:- Public property
    
    // MARK:- Private property
    
    // MARK:- Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
    }
    
    // MARK:- Layouts
    private func initView() {
     
        backgroundColor = .black
        nameLabel.text = nil
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
    }
    
    // MARK:- Public methods
    func bindToViewModel(_ viewModel: StockMarketListCellViewModel) {
        
        nameLabel.text = viewModel.name
        accessoryType = viewModel.isSelected ? .checkmark : .none
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
}
