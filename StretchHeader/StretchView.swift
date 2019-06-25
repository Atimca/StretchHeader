//
//  StretchView.swift
//  StretchHeaderDemo
//
//  Created by Smirnov Maxim on 10/04/2017.
//  Copyright © 2017 h.yamaguchi. All rights reserved.
//

import UIKit

class StretchView: StretchHeader {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        addSubview(label)
        NSLayoutConstraint
            .activate([label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                       label.topAnchor.constraint(equalTo: topAnchor, constant: 100),
                       label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)])
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        addSubview(view)
        NSLayoutConstraint
            .activate([view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                       view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                       view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                       view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
                       view.heightAnchor.constraint(equalToConstant: 60)])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
