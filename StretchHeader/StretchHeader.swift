//
//  StretchHeader.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/24.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxOptional

// MARK: - UIScrollView Extension

class StretchHeader: UIView {
    
    let strechView = UIView()
    private var contentSize = CGSize.zero
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        
        addSubview(strechView)
        sendSubviewToBack(strechView)
        
        rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .map { $0?.size }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.strechView.bounds.size = $0
                self.contentSize = $0
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public
    func updateStretch(withScrollViewOffset scrollOffset: CGFloat) {
        if scrollOffset < 0 {
            strechView.frame = CGRect(x: scrollOffset,
                                     y: scrollOffset,
                                     width: contentSize.width - (scrollOffset * 2),
                                     height: contentSize.height - scrollOffset)
        } else {
            strechView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
        }
    }
}
