//
//  StretchHeader.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/24.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit
import RxSwift
import RxOptional

class StretchHeader: UIView {
    
    private let strechView = UIView()
    private var contentSize: CGSize = .zero
    private let disposeBag = DisposeBag()
    
    init(scrollOffsetObservable: Observable<CGFloat>) {
        super.init(frame: CGRect.zero)
        
        addSubview(strechView)
        sendSubviewToBack(strechView)
        
        let bounds = rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .map { $0?.size }
            .filterNil()
        
        bounds
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.strechView.bounds.size = $0
                self.contentSize = $0
            })
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(scrollOffsetObservable, bounds) { inset, _ in return inset }
            .subscribe(onNext: updateStretch)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateStretch(withScrollViewOffset scrollOffset: CGFloat) {
        if scrollOffset < 0 {
            strechView.frame = CGRect(x: scrollOffset,
                                      y: scrollOffset,
                                      width: contentSize.width - (scrollOffset * 2),
                                      height: contentSize.height - scrollOffset)
        } else {
            strechView.frame = CGRect(origin: .zero, size: contentSize)
        }
    }
    
    func addStrechView(_ view: UIView) {
        strechView.subviews.forEach { $0.removeFromSuperview() }
        view.translatesAutoresizingMaskIntoConstraints = false
        strechView.addSubview(view)
        NSLayoutConstraint
            .activate([view.leadingAnchor.constraint(equalTo: strechView.leadingAnchor),
                       view.topAnchor.constraint(equalTo: strechView.topAnchor),
                       view.trailingAnchor.constraint(equalTo: strechView.trailingAnchor),
                       view.bottomAnchor.constraint(equalTo: strechView.bottomAnchor)])
    }
}
