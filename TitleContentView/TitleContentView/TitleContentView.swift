//
//  TitleContentView.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

class TitleContentView: UIView {
    
    var style: PageStyle
    var titles: [String]
    var childVCs: [UIViewController]
    var parentVC: UIViewController
    
    init(frame: CGRect, style: PageStyle, titles: [String], childVCs: [UIViewController], parentVC: UIViewController) {
        self.style = style
        self.titles = titles
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleContentView {
    
    func setupSubviews() {
        
        // 1. 添加titleView
        let titleView = TitleView(frame: bounds, style: self.style, titles: self.titles)
        titleView.backgroundColor = style.titleViewBackgroundColor
        addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: style.titleViewHeight).isActive = true
        
        // 2. 添加contentView
        let contentView = ContentView(frame: frame, style: self.style, childVCs: self.childVCs, parentVC: self.parentVC)
        contentView.backgroundColor = style.contentViewBackgroundColor
        insertSubview(contentView, belowSubview: titleView)
        
        // 3. 设置标题栏和控制器的代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
