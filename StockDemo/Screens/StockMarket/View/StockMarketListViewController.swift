//
//  StockMarketListViewController.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/6.
//

import UIKit

class StockMarketListViewController: UIViewController, UITextFieldDelegate {
    // MARK:- Outlets
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet var settingView: UIView!
    @IBOutlet weak var settingContentView: UIView!
    @IBOutlet weak var settingConfirmButton: UIButton!
    @IBOutlet weak var updateTimeTextField: UITextField!
    
    // MARK:- Public property
    
    // MARK:- Private property
    private let viewModel = StockMarketListViewModel()
    private var currentTimeValue = Int(PriceUpdateService.defaultService.updateInterval * 1000)
    private var newTimeValue = Int(PriceUpdateService.defaultService.updateInterval * 1000) 
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        configureListTableView()
        
        viewModel.updateClosure = { [weak self] in
            guard let self = self else { return }
            
            self.listTableView.reloadData()
        }
    }
    
    // MARK:- Layouts
    private func initView() {
        // updateTimeTextField
        updateTimeTextField.delegate = self
        updateTimeTextField.returnKeyType = .done
        updateTimeTextField.keyboardType = .numberPad
        updateTimeTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        updateTimeTextField.text = String(format: "%d", currentTimeValue)
        // settingView
        settingView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSettingView))
        settingView.addGestureRecognizer(tapGesture)
        view.addSubview(settingView)
        settingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingView.topAnchor.constraint(equalTo: view.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            settingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // settingContentView
        settingContentView.layer.cornerRadius = 8.0
        settingContentView.layer.shadowColor = UIColor.white.withAlphaComponent(0.5).cgColor
        settingContentView.layer.shadowRadius = 6.0
        settingContentView.layer.shadowOpacity = 0.5
        settingContentView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        // settingConfirmButton
        settingConfirmButton.layer.borderWidth = 1.0
        settingConfirmButton.layer.borderColor = UIColor.white.cgColor
    }
    
    private func configureListTableView() {
        
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.backgroundColor = .black
        listTableView.separatorStyle = .none
        listTableView.tableFooterView = UIView()
        let cellNib = UINib(nibName: "StockMarketListCell", bundle: nil)
        listTableView.register(cellNib, forCellReuseIdentifier: "StockMarketListCell")
    }
    
    // MARK:- Public methods
    func setStockMarketData(_ stockMarket: StockMarket) {
        viewModel.setStockMarket(stockMarket)
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
    @IBAction func selectAllButtonPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func deselectAllButtonPressed(_ sender: UIButton) {
    
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
    
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            
            self.settingView.alpha = 1.0
        } completion: { _ in }
    }
    
    @IBAction func settingConfirmButtonPressed(_ sender: Any) {
     
        currentTimeValue = newTimeValue
        PriceUpdateService.defaultService.updateInterval = Double(currentTimeValue) / 1000.0
        dismissSettingView()
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        guard let text = textField.text, let timeValue = Int(text) else { return }
        
        newTimeValue = timeValue
    }
    
    @objc private func dismissSettingView() {
         
        updateTimeTextField.resignFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.settingView.alpha = 0.0
        }
    }
    
    // MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension StockMarketListViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockMarketListCell", for: indexPath) as! StockMarketListCell
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cell.bindToViewModel(cellViewModel)
        return cell
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellViewModel = viewModel.toggleStockItemSaveState(index: indexPath.row)
        if let cell = tableView.cellForRow(at: indexPath) as? StockMarketListCell {
            cell.bindToViewModel(cellViewModel)
        }
    }
}
