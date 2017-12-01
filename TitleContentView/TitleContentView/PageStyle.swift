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
    var titleViewColor: UIColor = UIColor.yellow
    // 标题栏的告诉
    var titleViewHeight: CGFloat = 49
    // 标题栏是否可以滚动
    var isScrollEnable: Bool = true
    // 标题栏可以滚动（isScrollEnable = true）时label的外边距
    var titleLabelMarginWhenIsScrollTrue: CGFloat = 20
    // 标题栏不可以滚动时（isScrollEnable = false）时label的外边距
    var titleLabelMarginWhenIsScrollFalse: CGFloat = 30
    // 首次进入默认选中的标题
    var defaultSelectedIndex: Int = 0
    // 选中文字的缩放比例
    var isNeedScale: Bool = true
    // 当选中文字可以缩放（isNeedScale = true）文字的最大缩放比
    var maxScale: CGFloat = 1.3
    
    var titleFont = UIFont(name: "PingFangSC-Semibold", size: 15)!
    var titleSelectedFont = UIFont(name: "PingFangSC-Semibold", size: 15)!
    /// 标题颜色必须使用RGB值创建（目的：动态更改标题颜色通过动态改变RGB值实现）
    var titleTextColor = UIColor(red: 155/255.0, green: 48/255.0, blue: 255/255.0, alpha: 1.0)
    /// 标题颜色必须使用RGB值创建（目的：动态更改标题颜色通过动态改变RGB值实现）
    var titleSelectedTextColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
    
    //MARK: - BottomLine
    var isShowBottomLine: Bool = true
    var bottomLineHeight: CGFloat = 3
    var bottomLineWidth: CGFloat?
    
    //MARK: - CoverView
    var isShowCoverView: Bool = true
    var coverViewColor : UIColor = UIColor.blue    // 遮盖的颜色
    var coverViewAlpha : CGFloat = 0.3              // 遮盖的透明度
    var coverViewHeight : CGFloat = 40              // 遮盖的高度
    var coverViewRadius : CGFloat = 12              // 圆角的大小
    var coverViewMargin : CGFloat = 5               // 遮盖的间距
}
