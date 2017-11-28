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
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleContentView {
    
    func setupUI() {
     
        // 1. 添加titleView
        let titleViewFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleViewHeight)
        let titleView = TitleView(frame: titleViewFrame, style: self.style, titles: self.titles)
        addSubview(titleView)
        
        // 2. 添加contentView
        let contentViewFrame = CGRect(x: 0, y: self.style.titleViewHeight, width: self.bounds.width, height: self.bounds.height - self.style.titleViewHeight)
        let contentView = ContentView(frame: contentViewFrame, style: self.style, childVCs: self.childVCs, parentVC: self.parentVC)
        addSubview(contentView)
        
        // 3. 设置标题栏和控制器的代理
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
