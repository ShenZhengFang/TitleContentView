//
//  ViewController.swift
//  TitleContentView
//
//  Created by brian on 2017/11/27.
//  Copyright © 2017年 brian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["iPhone", "iOS", "KobeBryant", "优土视真", "UtoVR", "shenzhengfang", "JustinBieber", "中国", "Taylor Swift"]
//        let titles = ["我关注的", "最新上传", "精选推荐"]
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let style = PageStyle()
        style.isScrollEnable = false
        let frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: self.view.bounds.width, height: self.view.bounds.height - UIApplication.shared.statusBarFrame.size.height)
        let titleContentView = TitleContentView(frame: frame, style: style, titles: titles, childVCs: childVCs, parentVC: self)
        view.addSubview(titleContentView)
    }
}

