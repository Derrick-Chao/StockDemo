//
//  LeftTableViewCell.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import UIKit

class LeftTableViewCell: UITableViewCell {
    // MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK:- Public property
    
    // MARK:- Private property
    
    // MARK:- Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    // MARK:- Layouts
    private func initView() {
        
        backgroundColor = .black
        titleLabel.textColor = .white
    }
    
    // MARK:- Public methods
    
    // MARK:- Private methods
    
    // MARK:- Actions
}
