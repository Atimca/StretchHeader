//
//  Demo5Controller.swift
//  StretchHeaderDemo
//
//  Created by Smirnov Maxim on 10/04/2017.
//  Copyright © 2017 h.yamaguchi. All rights reserved.
//

import UIKit
import RxSwift

class Demo5Controller: UIViewController {
    
    private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        setupHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presumeContentOverSafeArea()
    }
    
    /// Should be called in viewDidLayoutSubviews.
    private func presumeContentOverSafeArea() {
        if #available(iOS 11.0, *) {
            tableView.scrollIndicatorInsets = view.safeAreaInsets
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        }
    }
    
    private func setupHeaderView() {
        enableScrollViewBehindStatusBar()
        let header = StretchView(scrollOffsetObservable: tableView.rx.contentOffset.map { $0.y })
        let imageView = UIImageView(image: UIImage(named: "photo_sample_05"))
        header.addStrechView(imageView)
        // Works only before setting to tableHeaderView for ios 10 and below.
        layoutTableHeaderView(headerView: header)
        tableView.tableHeaderView = header
    }
    
    private func enableScrollViewBehindStatusBar() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension Demo5Controller: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        return cell
    }
}

extension UIViewController {
    /// Need to call for autolayout calculation in tableView.tableHeaderView.
    /// Works only before setting to tableHeaderView for ios 10 and below.
    func layoutTableHeaderView(headerView: UIView) {
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstrant = headerView.widthAnchor.constraint(equalToConstant: view.bounds.size.width)
        widthConstrant.isActive = true
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        headerView.bounds.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        headerView.removeConstraint(widthConstrant)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
