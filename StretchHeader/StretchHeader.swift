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

open class StretchHeader: UIView {
    
    open var imageView: UIImageView!
    private var contentSize = CGSize.zero
    private var topInset : CGFloat = 0
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    fileprivate func commonInit() {
        imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        sendSubviewToBack(imageView)
        
        rx.observe(CGRect.self, #keyPath(UIView.bounds))
            .map { $0?.size }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.imageView.bounds.size = $0
                self.contentSize = $0
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Public
    open func updateStretch(withScrollViewOffset offset: CGPoint) {
        
        if imageView == nil { return }
        var scrollOffset : CGFloat = offset.y
        scrollOffset += topInset
        
        if scrollOffset < 0 {
            imageView.frame = CGRect(x: scrollOffset ,y: scrollOffset, width: contentSize.width - (scrollOffset * 2) , height: contentSize.height - scrollOffset);
        } else {
            imageView.frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height);
        }
        
    }
    
//    /// Can be overriden for custom animation
//    open func updateNavigationView(withScrollViewOffset offset: CGPoint) {
//
//        guard let navigationView = self.navigationView else {
//            return
//        }
//
//        // NavigationHeader alpha update
//        let offsetY : CGFloat = offset.y
//        if (offsetY > 50) {
//            let alpha : CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(50) + (navigationView.frame.height) - offsetY) / (navigationView.frame.height))
//            navigationView.alpha = CGFloat(alpha)
//
//        } else {
//            navigationView.alpha = 0.0;
//        }
//
//    }
}
