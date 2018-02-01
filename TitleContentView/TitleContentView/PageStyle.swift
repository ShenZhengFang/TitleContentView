//
//  PageStyle.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

class PageStyle: NSObject {

    //MARK: - TitleView
    var titleViewHeight: CGFloat = 44
    var titleViewBackgroundColor: UIColor = UIColor.green
    var scrollViewBackgroundColor: UIColor = UIColor.cyan
    var isScrollEnable: Bool = true
    var titleLabelMargin: CGFloat = 20
    var selectedIndex: Int = 0
    var isNeedScale: Bool = true
    var maxScale: CGFloat = 1.1
    var font = UIFont(name: "PingFangSC-Semibold", size: 15)!
    var selectedFont = UIFont(name: "PingFangSC-Semibold", size: 15)!
    var textColor = UIColor(red: 155/255.0, green: 48/255.0, blue: 255/255.0, alpha: 1.0)
    var selectedTextColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    //MARK: - ContentView
    var contentViewBackgroundColor: UIColor = UIColor.yellow
    var contentViewTopOffset: CGFloat = 0
    var contentViewBottomOffset: CGFloat = 0
    
    
    //MARK: - BottomLine
    var isShowBottomLine: Bool = true
    var bottomLineHeight: CGFloat = 3
    var bottomLineWidth: CGFloat?
    
    //MARK: - CoverView
    var isShowCoverView: Bool = true
    var coverViewBackgroundColor : UIColor = UIColor.blue
    var coverViewAlpha : CGFloat = 0.3
    var coverViewHeight : CGFloat = 40
    var coverViewRadius : CGFloat = 12
    var coverViewMargin : CGFloat = 5
}
