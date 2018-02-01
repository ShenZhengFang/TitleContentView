//
//  TitleView.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

protocol TitleViewDelegate: class {
    // 切换内容控制器
    func titleView(titleView: TitleView, currentIndex: Int)
}

class TitleView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = style.scrollViewBackgroundColor
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var bottomLine: UIView = {
        let bottomLine: UIView = UIView()
        bottomLine.backgroundColor = style.selectedTextColor
        return bottomLine
    }()
    
    lazy var coverView: UIView = {
        let coverView: UIView = UIView()
        coverView.backgroundColor = style.coverViewBackgroundColor
        coverView.alpha = style.coverViewAlpha
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    var labelArray = [UILabel]()
    weak var delegate: TitleViewDelegate?
    
    fileprivate var currentIndex: Int = 0
    fileprivate var previousIndex: Int = 0
    
    //根据UIColor(r,g,b)获取一个保存颜色RBG值得元组
    fileprivate lazy var textColorRGB : (CGFloat, CGFloat, CGFloat) = self.style.textColor.getRGBValue()
    fileprivate lazy var selectedTextColorRGB : (CGFloat, CGFloat, CGFloat) = self.style.selectedTextColor.getRGBValue()
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
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleView {
    
    func setupSubviews() {
        
        // 1. UIScrollView实现滚动标题栏
        addScrollView()
        
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
    
    func addScrollView() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func addTitleLabel() {
        // 1. 创建Label，设置属性
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            label.font = style.font
            label.textColor = style.textColor
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
            labelX = index == 0 ? style.titleLabelMargin : labelArray[index - 1].frame.maxX + style.titleLabelMargin
            if style.isScrollEnable {
                labelW = (label.text! as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.titleViewHeight), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: style.selectedFont], context: nil).size.width
                label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
                // 设置ScrollView的contentSize
                scrollView.contentSize = CGSize(width: (labelArray.last?.frame.maxX)! + style.titleLabelMargin, height: style.titleViewHeight)
            } else {
                let middleMarginCount = CGFloat(labelArray.count + 1)
                labelW = (self.bounds.width - middleMarginCount * style.titleLabelMargin) / CGFloat(labelArray.count)
                label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            }
        }
        
        // 3. 设置默认选中的Label的样式
        labelArray[style.selectedIndex].textColor = style.selectedTextColor
        labelArray[style.selectedIndex].font = style.selectedFont
        
        // 4. 设置默认选中文字的缩放
        if style.isNeedScale {
            labelArray[style.selectedIndex].transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
    }
    
    // 添加下划线
    func addBottomLine() {
        scrollView.addSubview(bottomLine)
        bottomLine.frame = labelArray[style.selectedIndex].frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleViewHeight - style.bottomLineHeight
        if let bottomLineWidth = style.bottomLineWidth {
            bottomLine.frame.size.width = bottomLineWidth
            bottomLine.frame.origin.x = labelArray[style.selectedIndex].frame.midX - bottomLineWidth * 0.5
        } else {
            bottomLine.frame.size.width = labelArray[style.selectedIndex].frame.size.width
            bottomLine.frame.origin.x = labelArray[style.selectedIndex].frame.midX - bottomLine.bounds.width * 0.5
        }
    }
    
    // 添加遮盖View
    func addCoverView() {
        scrollView.insertSubview(coverView, at: 0)
        coverView.frame = labelArray[style.selectedIndex].frame
        coverView.frame.size.height = style.coverViewHeight
        coverView.frame.origin.y = (style.titleViewHeight - style.coverViewHeight) * 0.5
        if style.isScrollEnable {
            coverView.frame.size.width = labelArray[style.selectedIndex].frame.size.width + style.coverViewMargin * 2
            coverView.frame.origin.x = labelArray[style.selectedIndex].frame.origin.x - style.coverViewMargin
        }
    }
}

//MARK: - Label Event
extension TitleView {
    
    @objc fileprivate func labelClick(tapGesture: UITapGestureRecognizer) {
        
        // 1. 获取当前选中的label
        guard let currentLabel = tapGesture.view as? UILabel else {return}
        
        // 2. 设置上一次选中的label的颜色
        previousIndex = currentIndex
        labelArray[previousIndex].textColor = style.textColor
        labelArray[previousIndex].font = style.font
        
        // 3. 设置当前选中label的颜色
        currentLabel.textColor = style.selectedTextColor
        currentLabel.font = style.selectedFont
        currentIndex = currentLabel.tag
        
        // 4. 设置当前选中的label的位置
        if style.isScrollEnable {
            adjustCurrentLabelPosition()
        }
        
        // 5. 调整文字的缩放
        if style.isNeedScale {
            UIView.animate(withDuration: 0.3, animations: {
                self.labelArray[self.previousIndex].transform = CGAffineTransform.identity
                self.labelArray[self.currentIndex].transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        // 6. 调整bottomLine的位置
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
        
        // 7. 调整遮盖View的位置
        if style.isShowCoverView {
            UIView.animate(withDuration: 0.3, animations: {
                if self.style.isScrollEnable {
                    self.coverView.frame.origin.x = self.labelArray[self.currentIndex].frame.origin.x - self.style.coverViewMargin
                    self.coverView.frame.size.width = self.labelArray[self.currentIndex].frame.size.width + self.style.coverViewMargin * 2
                } else {
                    self.coverView.frame.origin.x = self.labelArray[self.currentIndex].frame.origin.x
                    self.coverView.frame.size.width = self.labelArray[self.currentIndex].frame.size.width
                }
            })
        }
        
        // 8. 通知contentView切换VC
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
        let xRange = currentLabel.frame.midX - previousLabel.frame.midX
        if style.isShowBottomLine {
            if let bottomLineWidth = style.bottomLineWidth {
                bottomLine.frame.origin.x = previousLabel.frame.midX + xRange * progress - bottomLineWidth * 0.5
            } else {
                bottomLine.frame.size.width = previousLabel.frame.width + widthRange * progress
                bottomLine.frame.origin.x = previousLabel.frame.midX + xRange * progress - bottomLine.bounds.width * 0.5
            }
        }
        
        //5. 调整coverView的位置
        if style.isShowCoverView {
            if style.isScrollEnable {
                coverView.frame.size.width = previousLabel.frame.size.width + style.coverViewMargin * 2 + widthRange * progress
                coverView.frame.origin.x = previousLabel.frame.midX + xRange * progress - coverView.bounds.width * 0.5
            } else {
                coverView.frame.size.width = previousLabel.frame.size.width + widthRange * progress
                coverView.frame.origin.x = previousLabel.frame.midX + xRange * progress - coverView.frame.width * 0.5
            }
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
