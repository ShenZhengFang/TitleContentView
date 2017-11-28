
//
//  UIColor-Extension.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func randomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(255))/255
        let green = CGFloat(arc4random_uniform(255))/255
        let blue = CGFloat(arc4random_uniform(255))/255
        let randomColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        return randomColor
    }
    
    /*
     1. 在类扩展中扩充构造函数必须扩充便利构造函数
     2. 所谓便利构造函数就是在init前加convenience
     3. 便利构造函数一定要调用原有类的一个构造函数
     */
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
}


