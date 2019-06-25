//
//  Demo5Controller.swift
//  StretchHeaderDemo
//
//  Created by Smirnov Maxim on 10/04/2017.
//  Copyright © 2017 h.yamaguchi. All rights reserved.
//

import UIKit

class Demo5Controller: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //var header : StretchHeader!
    var tableView : UITableView!
    var navigationView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        // NavigationHeader
        let navibarHeight : CGFloat = navigationController!.navigationBar.bounds.height
        let statusbarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: navibarHeight + statusbarHeight)
        navigationView.backgroundColor = UIColor(red: 121/255.0, green: 193/255.0, blue: 203/255.0, alpha: 1.0)
        navigationView.alpha = 0.0
        view.addSubview(navigationView)
        
        // back button
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 10, y: 20, width: 44, height: 44)
        button.setImage(UIImage(named: "navi_back_btn")?.withRenderingMode(.alwaysTemplate), for: UIControl.State())
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        view.addSubview(button)
        
        setupHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTableHeaderView()
        if #available(iOS 11.0, *) {
            tableView.scrollIndicatorInsets = view.safeAreaInsets
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func setupHeaderView() {
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        let options = StretchHeaderOptions()
        options.position = .fullScreenTop
        options.scrollUpdateMethod = .notification
        options.isNavigationViewAnimated = true
        
        let header = Bundle.main.loadNibNamed("StretchView", owner: nil, options: nil)?.first as! StretchView
        header.frame.origin.y = -44
        header.setup(options: options, withController: self, navigationView: self.navigationView)
        header.imageView.image = UIImage(named: "photo_sample_05")
        
        tableView.tableHeaderView = header
    }
    
    // MARK: - Selector
    @objc func leftButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        cell.textLabel?.text = "index -- \((indexPath as NSIndexPath).row)"
        return cell
    }
    
    func layoutTableHeaderView() {
        
        guard let headerView = tableView.tableHeaderView as? StretchHeader else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstrant = headerView.widthAnchor.constraint(equalToConstant: headerView.bounds.size.width)
        widthConstrant.isActive = true
        
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        headerView.bounds.size.height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        headerView.setup(imageSize: headerView.bounds.size)
        
        headerView.removeConstraint(widthConstrant)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }
}
