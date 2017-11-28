//
//  TitleView.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

protocol TitleViewDelegate: class {
    // 切换控制器
    func titleView(titleView: TitleView, currentIndex: Int)
}

class TitleView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    lazy var bottomLine: UIView = {
        let bottomLine: UIView = UIView()
        return bottomLine
    }()
    lazy var coverView: UIView = {
        let coverView: UIView = UIView()
        return coverView
    }()
    
    var labelArray = [UILabel]()
    weak var delegate: TitleViewDelegate?
    
    fileprivate var currentIndex: Int = 0
    fileprivate var previousIndex: Int = 0
    
    //根据UIColor(r,g,b)获取一个保存颜色RBG值得元组
    fileprivate lazy var textColorRGB : (CGFloat, CGFloat, CGFloat) = self.style.titleTextColor.getRGBValue()
    fileprivate lazy var selectedTextColorRGB : (CGFloat, CGFloat, CGFloat) = self.style.titleSelectedTextColor.getRGBValue()
    //根据上面两个颜色求颜色变化的范围
    fileprivate lazy var colorRange : (CGFloat, CGFloat, CGFloat) = {
        let colorRange = (self.selectedTextColorRGB.0 - self.textColorRGB.0, self.selectedTextColorRGB.1 - self.textColorRGB.1, self.selectedTextColorRGB.2 - self.textColorRGB.2)
        return colorRange
    }()

    var style: PageStyle
    var titles: [String]
    
    init(frame: CGRect, style: PageStyle, titles: [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupUI()
        defaultSetting()
    }
    
    func defaultSetting() {
        // 1. 设置默认选中的Label的样式
        labelArray[style.defaultSelectedIndex].textColor = style.titleSelectedTextColor
        labelArray[style.defaultSelectedIndex].font = style.titleSelectedFont
        currentIndex = style.defaultSelectedIndex
        
        // 2. 设置默认选中文字的缩放
        if style.isNeedScale {
            labelArray[style.defaultSelectedIndex].transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
            coverView.frame.size.width = labelArray[style.defaultSelectedIndex].frame.size.width + style.coverViewMargin * 2
            coverView.frame.origin.x = labelArray[style.defaultSelectedIndex].frame.origin.x - style.coverViewMargin
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    
    func setupUI() {
        
        self.backgroundColor = style.titleViewColor
        
        // 1. UIScrollView实现滚动标题栏
        addSubview(scrollView)
        // 2. 添加标题
        addTitleLabel()
        // 3. 添加文字下划线
        if style.isShowBottomLine {
            addBottomLine()
        }
        // 4. 添加coverView
        if style.isShowCoverView {
            addCoverView()
        }
    }
    
    func addTitleLabel() {
        // 1. 创建Label，设置属性
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.font = style.titleFont
            label.textColor = style.titleTextColor
            label.tag = index
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelClick(tapGesture:)))
            label.addGestureRecognizer(tapGesture)
            scrollView.addSubview(label)
            labelArray.append(label)
        }
        // 2. 设置Label的frame
        var labelX: CGFloat = 0
        let labelY: CGFloat = 0
        var labelW: CGFloat = 0
        let labelH: CGFloat = style.titleViewHeight - style.bottomLineHeight
        for (index, label) in labelArray.enumerated() {
            if style.isScrollEnable {
                labelW = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.titleViewHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: style.titleSelectedFont], context: nil).size.width
                labelX = index == 0 ? style.titleLabelMargin : labelArray[index-1].frame.maxX + style.titleLabelMargin
                label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
                
                // 设置ScrollView的contentSize
                scrollView.contentSize = CGSize(width: (labelArray.last?.frame.maxX)! + style.titleLabelMargin, height: style.titleViewHeight)
            } else {
                labelW = self.bounds.width / CGFloat(labelArray.count)
                labelX = labelW * CGFloat(index)
                label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            }
        }
    }
    
    // 添加下划线
    func addBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.backgroundColor = style.titleSelectedTextColor
        bottomLine.frame = labelArray[style.defaultSelectedIndex].frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleViewHeight - style.bottomLineHeight
        if let bottomLineWidth = style.bottomLineWidth {
            bottomLine.frame.size.width = bottomLineWidth
            bottomLine.frame.origin.x = labelArray[style.defaultSelectedIndex].frame.midX - bottomLineWidth * 0.5
        }
    }
    
    // 添加遮盖View
    func addCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        coverView.backgroundColor = style.coverViewColor
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
        coverView.alpha = style.coverViewAlpha
        // frame
        coverView.frame = labelArray[style.defaultSelectedIndex].frame
        coverView.frame.size.height = style.coverViewHeight
        coverView.frame.origin.y = labelArray[style.defaultSelectedIndex].frame.origin.y + (style.titleViewHeight - style.coverViewHeight) * 0.5
        coverView.frame.size.width = labelArray[style.defaultSelectedIndex].frame.size.width + style.coverViewMargin * 2
        coverView.frame.origin.x = labelArray[style.defaultSelectedIndex].frame.origin.x - style.coverViewMargin
    }
}

//MARK: - Label Event
extension TitleView {
    
    @objc func labelClick(tapGesture: UITapGestureRecognizer) {
        // 1. 获取当前选中的label
        guard let currentLabel = tapGesture.view as? UILabel else {return}
        
        // 2. 设置上一次选中的label的颜色
        previousIndex = currentIndex
        labelArray[previousIndex].textColor = style.titleTextColor
        labelArray[previousIndex].font = style.titleFont
        
        // 3. 设置当前选中label的颜色
        currentLabel.textColor = style.titleSelectedTextColor
        currentLabel.font = style.titleSelectedFont
        currentIndex = currentLabel.tag
        
        // 4. 设置当前选中的label的位置
        if style.isScrollEnable {
            adjustCurrentLabelPosition()
        }
        
        // 5. 调整bottomLine的位置
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.3, animations: {
                if let bottomLineWidth = self.style.bottomLineWidth {
                    self.bottomLine.frame.origin.x = currentLabel.frame.midX - bottomLineWidth * 0.5
                } else {
                    self.bottomLine.frame.size.width = currentLabel.frame.width
                    self.bottomLine.frame.origin.x = currentLabel.frame.origin.x
                }
            })
        }
        
        // 6. 调整文字的缩放
        if style.isNeedScale {
            UIView.animate(withDuration: 0.3, animations: {
                self.labelArray[self.previousIndex].transform = CGAffineTransform.identity
                self.labelArray[self.currentIndex].transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        // 7. 调整遮盖View的位置
        if style.isShowCoverView {
            UIView.animate(withDuration: 0.3, animations: {
                self.coverView.frame.origin.x = self.style.isScrollEnable ? self.labelArray[self.currentIndex].frame.origin.x - self.style.coverViewMargin : self.labelArray[self.currentIndex].frame.origin.x
                self.coverView.frame.size.width = self.style.isScrollEnable ? self.labelArray[self.currentIndex].frame.size.width + self.style.coverViewMargin * 2 : self.labelArray[self.currentIndex].frame.size.width
            })
        }
        
        // 7. 通知内容View
        delegate?.titleView(titleView: self, currentIndex: currentIndex)
    }
    
    // 点击文字后调整选中文字的位置到屏幕中心
    fileprivate func adjustCurrentLabelPosition() {
        //1. 获取当前选中的label距离屏幕中心位置的距离
        var offsetX = labelArray[currentIndex].center.x - bounds.width * 0.5
        
        //2. 如果label中心点距离屏幕中心点的距离小于0，代表label不要移动
        if offsetX < 0 {
            offsetX = 0
        }
        
        //3. 如果label中心点距离屏幕右边的距离小于屏幕宽度的一半，同样label不需要移动
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        // 5. 设置scrollView的contentOffset，使选中的label处于屏幕中间位置
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

//MARK: - ContentViewDelegate
extension TitleView: ContentViewDelegate {
    
    func contentView(contentView: ContentView, currentIndex: Int, previousIndex: Int, progress: CGFloat) {
        
        self.currentIndex = currentIndex
        self.previousIndex = previousIndex
        // 1. 获取上一个选中的label和当前选中的label
        let currentLabel = labelArray[currentIndex]
        let previousLabel = labelArray[previousIndex]
        
        // 2. 设置颜色的变化
        //2. 懒加载获取颜色变化的范围
        //3. 根据颜色范围设置当前选中的label的颜色和上一个选中的label的颜色
        let selectedRed = (textColorRGB.0 + colorRange.0 * progress)/255
        let selectedGreen = (textColorRGB.1 + colorRange.1 * progress)/255
        let selectedBlue = (textColorRGB.2 + colorRange.2 * progress)/255
        currentLabel.textColor = UIColor(red: selectedRed, green: selectedGreen, blue: selectedBlue, alpha: 1.0)
        let red = (selectedTextColorRGB.0 - colorRange.0 * progress)/255
        let green = (selectedTextColorRGB.1 - colorRange.1 * progress)/255
        let blue = (selectedTextColorRGB.2 - colorRange.2 * progress)/255
        previousLabel.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        

        //3. 调整文字缩放
        if style.isNeedScale {
            let scaleRange = style.maxScale - 1.0
            previousLabel.transform = CGAffineTransform(scaleX: (style.maxScale - scaleRange * progress), y: (style.maxScale - scaleRange * progress))
            currentLabel.transform = CGAffineTransform(scaleX: (1.0 + scaleRange * progress), y: (1.0 + scaleRange * progress))
        }
        
        //4. 调整bottomLine的位置
        let widthRange = currentLabel.frame.width - previousLabel.frame.width
        let xRange = currentLabel.frame.origin.x - previousLabel.frame.origin.x
        if style.isShowBottomLine {
            if let bottomLineWidth = style.bottomLineWidth {
                bottomLine.frame.origin.x = previousLabel.frame.midX + xRange * progress - bottomLineWidth * 0.5
            } else {
                bottomLine.frame.size.width = previousLabel.frame.width + widthRange * progress
                bottomLine.frame.origin.x = previousLabel.frame.origin.x + xRange * progress
            }
        }
        
        //5. 调整coverView的位置
        if style.isShowCoverView {
            coverView.frame.origin.x = style.isScrollEnable ? (previousLabel.frame.origin.x - style.coverViewMargin + xRange * progress) : (previousLabel.frame.origin.x + xRange * progress)
            coverView.frame.size.width = style.isScrollEnable ? (previousLabel.frame.size.width + style.coverViewMargin * 2 + widthRange * progress) : (previousLabel.frame.size.width + widthRange * progress)
        }
    }
    
    func contentView(contentView: ContentView, currentIndex: Int) {
        self.currentIndex = currentIndex
        adjustCurrentLabelPosition()
    }
}

extension UIColor {
    
    func getRGBValue() -> (CGFloat, CGFloat, CGFloat) {
        guard let components = self.cgColor.components else {
            fatalError("该颜色不是通过RGB创建的")
        }
        return (components[0] * 255, components[1] * 255, components[2] * 255)
    }
}
