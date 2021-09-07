//
//  MultiTableView.swift
//  StockDemo
//
//  Created by DerrickChao on 2021/9/7.
//

import UIKit

enum TableViewType {
    case left
    case right
}

enum MultiTableViewLayouts {
    case leftTableViewWidth
    case titleHeight
}

extension MultiTableViewLayouts: RawRepresentable {
    typealias RawValue = CGFloat
    
    init?(rawValue: CGFloat) {
        return nil
    }
    
    var rawValue: CGFloat {
        switch self {
        case .leftTableViewWidth:
            return 100.0
        case .titleHeight:
            return 50.0
        }
    }
}

protocol MultiTableViewDataSource: AnyObject {
    func multiTableViewForTopLeftTitleView(_ multiTableView: MultiTableView) -> UIView?
    func numberOfRows(in multiTableView: MultiTableView) -> Int
    func multiTableView(_ tableView: UITableView, type: TableViewType, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    func multiTableViewRowHeight(_ multiTableView: MultiTableView) -> CGFloat
    func multiTableViewTopTitles(_ multiTableView: MultiTableView) -> [String]
}

class MultiTableView: UIView, UIScrollViewDelegate {
    // MARK:- Public property
    weak var dataSource: MultiTableViewDataSource?
    
    var rightColumnWidth: CGFloat = 50.0 {
        didSet {
            configureTopScrollView()
        }
    }
    
    // MARK:- Private property
    private lazy var leftTitleView: UIView = {
        let titleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: MultiTableViewLayouts.leftTableViewWidth.rawValue, height: MultiTableViewLayouts.titleHeight.rawValue))
        titleView.backgroundColor = .clear
        return titleView
    }()
    
    private lazy var containerScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var topScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .gray
        scrollView.delegate = self
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var leftTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var rightTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var rightTableViewWidthConstraint: NSLayoutConstraint!
    private var rightTableViewWidth: CGFloat = 0.0
    private var topTitleList: [String] = []
    
    private lazy var topTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        return stackView
    }()
    
    // MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        initView()
        initialLayouts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
        initialLayouts()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let forLeftTitleView = dataSource?.multiTableViewForTopLeftTitleView(self), leftTitleView.subviews.count == 0 else { return }
        
        forLeftTitleView.translatesAutoresizingMaskIntoConstraints = false
        leftTitleView.addSubview(forLeftTitleView)
        NSLayoutConstraint.activate([
            forLeftTitleView.topAnchor.constraint(equalTo: leftTitleView.topAnchor),
            forLeftTitleView.bottomAnchor.constraint(equalTo: leftTitleView.bottomAnchor),
            forLeftTitleView.leadingAnchor.constraint(equalTo: leftTitleView.leadingAnchor),
            forLeftTitleView.trailingAnchor.constraint(equalTo: leftTitleView.trailingAnchor)
        ])
    }
    
    // MARK:- Layouts
    private func initView() {
        
        addSubview(leftTitleView)
        addSubview(topScrollView)
        addSubview(containerScrollView)
        addSubview(leftTableView)
        containerScrollView.addSubview(rightTableView)
        let leftCellNib = UINib(nibName: "LeftTableViewCell", bundle: nil)
        leftTableView.register(leftCellNib, forCellReuseIdentifier: "LeftTableViewCell")
        let rightCellNib = UINib(nibName: "RightTableViewCell", bundle: nil)
        rightTableView.register(rightCellNib, forCellReuseIdentifier: "RightTableViewCell")
    }
    
    private func initialLayouts() {
        
        rightTableViewWidth = bounds.width - MultiTableViewLayouts.leftTableViewWidth.rawValue
//        print("rightTableViewWidth: \(rightTableViewWidth)")
        // leftTitleView
        leftTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftTitleView.topAnchor.constraint(equalTo: getTopAnchor()),
            leftTitleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftTitleView.widthAnchor.constraint(equalToConstant: MultiTableViewLayouts.leftTableViewWidth.rawValue),
            leftTitleView.heightAnchor.constraint(equalToConstant: MultiTableViewLayouts.titleHeight.rawValue)
        ])
        // topScrollView
        topScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topScrollView.topAnchor.constraint(equalTo: getTopAnchor()),
            topScrollView.leadingAnchor.constraint(equalTo: leftTitleView.trailingAnchor),
            topScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topScrollView.heightAnchor.constraint(equalToConstant: MultiTableViewLayouts.titleHeight.rawValue)
        ])
        topScrollView.contentSize = CGSize(width: rightTableViewWidth, height: MultiTableViewLayouts.titleHeight.rawValue)
        
        topTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        topScrollView.addSubview(topTitleStackView)
        NSLayoutConstraint.activate([
            topTitleStackView.leadingAnchor.constraint(equalTo: topScrollView.leadingAnchor),
            topTitleStackView.centerYAnchor.constraint(equalTo: topScrollView.centerYAnchor),
            topTitleStackView.heightAnchor.constraint(equalToConstant: MultiTableViewLayouts.titleHeight.rawValue)
        ])
        // containerScrollView
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: leftTitleView.bottomAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: getBottomAnchor()),
            containerScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: MultiTableViewLayouts.leftTableViewWidth.rawValue),
            containerScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        // leftTableView
        leftTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            leftTableView.widthAnchor.constraint(equalToConstant: MultiTableViewLayouts.leftTableViewWidth.rawValue),
            leftTableView.topAnchor.constraint(equalTo: leftTitleView.bottomAnchor),
            leftTableView.bottomAnchor.constraint(equalTo: getBottomAnchor())
        ])
        // rightTableView
        rightTableView.translatesAutoresizingMaskIntoConstraints = false
        rightTableViewWidthConstraint = rightTableView.widthAnchor.constraint(equalToConstant: rightTableViewWidth)
        NSLayoutConstraint.activate([
            rightTableView.centerYAnchor.constraint(equalTo: containerScrollView.centerYAnchor),
            rightTableView.leadingAnchor.constraint(equalTo: containerScrollView.leadingAnchor),
            rightTableViewWidthConstraint,
            rightTableView.heightAnchor.constraint(equalTo: containerScrollView.heightAnchor)
        ])
    }
    
    private func configureTopScrollView() {
        guard let dataSource = self.dataSource else { return }
        
        for view in topTitleStackView.arrangedSubviews {
            topTitleStackView.removeArrangedSubview(view)
        }
        
        topTitleList = dataSource.multiTableViewTopTitles(self)
        for (index, title) in topTitleList.enumerated() {
            
            let button = UIButton(type: .system)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
            button.setTitle(title, for: .normal)
            button.tag = index
            topTitleStackView.addArrangedSubview(button)
        }
        
        let width = rightColumnWidth * CGFloat(topTitleList.count)
        topTitleStackView.widthAnchor.constraint(equalToConstant: width).isActive = true
        rightTableViewWidth = width
        rightTableViewWidthConstraint.isActive = false
        rightTableViewWidthConstraint = rightTableView.widthAnchor.constraint(equalToConstant: rightTableViewWidth)
        rightTableViewWidthConstraint.isActive = true
        containerScrollView.contentSize = CGSize(width: rightTableViewWidth, height: 1.0)
    }
    
    private func getTopAnchor() -> NSLayoutYAxisAnchor {
        
        let anchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            anchor = safeAreaLayoutGuide.topAnchor
        } else {
            anchor = topAnchor
        }
        return anchor
    }
    
    private func getBottomAnchor() -> NSLayoutYAxisAnchor {
        
        let anchor: NSLayoutYAxisAnchor
        if #available(iOS 11.0, *) {
            anchor = safeAreaLayoutGuide.bottomAnchor
        } else {
            anchor = bottomAnchor
        }
        return anchor
    }
    
    // MARK:- Public methods
    func reloadData() {
        
        leftTableView.reloadData()
        rightTableView.reloadData()
    }
    
    // MARK:- Private methods
    
    // MARK:- Actions
    
    // MARK:- UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView === leftTableView || scrollView === rightTableView {
            // 控制上下滑
            var leftBounds = leftTableView.bounds
            leftBounds.origin.y = scrollView.contentOffset.y
            leftTableView.bounds = leftBounds
            var rightBounds = rightTableView.bounds
            rightBounds.origin.y = scrollView.contentOffset.y
            rightTableView.bounds = rightBounds
//            print("控制上下滑: \(scrollView.contentOffset), scrollView: \(scrollView)")
        }
        
        if scrollView === containerScrollView || scrollView === topScrollView {
            // 控制左右滑
            var containerBounds = containerScrollView.bounds
            containerBounds.origin.x = scrollView.contentOffset.x
            containerScrollView.bounds = containerBounds
            var topBounds = topScrollView.bounds
            topBounds.origin.x = scrollView.contentOffset.x
            topScrollView.bounds = topBounds
//            print("控制左右滑: \(scrollView.contentOffset)")
            if scrollView.contentOffset.x <= 0.0 {
                
                var containerBounds = containerScrollView.bounds
                containerBounds.origin.x = 0.0
                containerScrollView.bounds = containerBounds
                var topBounds = topScrollView.bounds
                topBounds.origin.x = 0.0
                topScrollView.bounds = topBounds
            }
        }
    }
    
}

extension MultiTableView: UITableViewDataSource, UITableViewDelegate {
    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(in: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = self.dataSource else {
            return UITableViewCell()
        }
        
        let type: TableViewType
        if tableView === leftTableView {
            type = .left
        } else {
            type = .right
        }
        return dataSource.multiTableView(tableView, type: type, cellForRowAtIndexPath: indexPath)
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.multiTableViewRowHeight(self) ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
