//
//  StretchHeader.swift
//  StretchHeaderDemo
//
//  Created by yamaguchi on 2016/03/24.
//  Copyright © 2016年 h.yamaguchi. All rights reserved.
//

import UIKit

// MARK: - UIScrollView Extension

open class StretchHeader: UIView {
    
    open var imageView: UIImageView!
    var navigationView: UIView?
    private weak var scrollView: UIScrollView?
    private var contentSize = CGSize.zero
    private var topInset : CGFloat = 0
    private var options: StretchHeaderOptions!
    private var isObservingScrollView: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func layoutTableHeaderView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = widthAnchor.constraint(equalToConstant: bounds.size.width)
        addConstraint(widthConstraint)
        
        setNeedsLayout()
        layoutIfNeeded()
        
        let calculatedHeight = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        frame.size.height = calculatedHeight
        setup(imageSize: .init(width: imageView.bounds.width, height: calculatedHeight))
        
        removeConstraint(widthConstraint)
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        guard options.scrollUpdateMethod == .notification else {
            return
        }
        
        if newWindow != nil {
            self.observeScrollViewIfPossible()
        } else {
            self.stopObservingScrollView()
        }
        
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard options.scrollUpdateMethod == .notification else {
            return
        }
        
        if (self.superview != self.scrollView) {
            self.stopObservingScrollView()
            self.scrollView = nil
        }
        
        if !(self.superview is UIScrollView) {
            return
        }
        
        self.scrollView = self.superview as? UIScrollView
        
        self.observeScrollViewIfPossible()
        layoutTableHeaderView()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        fatalError()
    }
    
    fileprivate func stopObservingScrollView() {
        
        guard let scrollView = self.scrollView, self.isObservingScrollView else {
            return
        }
        
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        
        self.isObservingScrollView = false
        
    }
    
    fileprivate func observeScrollViewIfPossible() {
        
        guard let scrollView = self.scrollView, !self.isObservingScrollView else {
            return
        }
        
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        self.isObservingScrollView = true
        
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
    }
    
    // MARK: Public
    
    /// Use with XIB init
    open func setup(options: StretchHeaderOptions, withController controller: UIViewController, navigationView: UIView? = nil) {
        
        let status_height = UIApplication.shared.statusBarFrame.height
        let navi_height = controller.navigationController?.navigationBar.frame.size.height ?? 44
        
        self.options = options
        
        if options.position == StretchHeaderOptions.HeaderPosition.fullScreenTop {
            controller.automaticallyAdjustsScrollViewInsets = false
        }
        
        if options.position == StretchHeaderOptions.HeaderPosition.underNavigationBar {
            if let translucent = controller.navigationController?.navigationBar.isTranslucent {
                if translucent {
                    topInset += status_height + navi_height
                }
            }
        }
        
        self.navigationView = navigationView
        
    }
    
    /// Size setup
    open func setup(imageSize: CGSize) {
        
        imageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        contentSize = imageSize        
    }
    
    /// Full setup. Use without XIB init
    open func stretchHeaderSize(imageSize: CGSize, controller: UIViewController, options: StretchHeaderOptions, navigationView: UIView? = nil) {
        
        setup(options: options, withController: controller, navigationView: navigationView)
        setup(imageSize: imageSize)
    }
    
    open func updateScrollViewOffset(_ scrollView: UIScrollView) {
        updateStretch(withScrollViewOffset: scrollView.contentOffset)
    }
    
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
    
    /// Can be overriden for custom animation
    open func updateNavigationView(withScrollViewOffset offset: CGPoint) {
        
        guard let navigationView = self.navigationView else {
            return
        }
        
        // NavigationHeader alpha update
        let offsetY : CGFloat = offset.y
        if (offsetY > 50) {
            let alpha : CGFloat = min(CGFloat(1), CGFloat(1) - (CGFloat(50) + (navigationView.frame.height) - offsetY) / (navigationView.frame.height))
            navigationView.alpha = CGFloat(alpha)
            
        } else {
            navigationView.alpha = 0.0;
        }
        
    }
    
    // MARK: - KVO
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentOffset", let offset = scrollView?.contentOffset {
            
            updateStretch(withScrollViewOffset: offset)
            
            if self.options.isNavigationViewAnimated {
                updateNavigationView(withScrollViewOffset: offset)
            }
            
        }
        
    }
    
}
