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
        
//        let titles = ["iPhone", "iOS", "KobeBryant", "优土视真", "UtoVR", "shenzhengfang", "JustinBieber", "中国", "Taylor Swift"]
        let titles = ["我关注的", "最新上传", "精选推荐"]
        
        var childVCs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
        let style = PageStyle()
        style.isScrollEnable = false
        let titleContentView = TitleContentView(frame: self.view.bounds, style: style, titles: titles, childVCs: childVCs, parentVC: self)
        titleContentView.backgroundColor = UIColor.orange
        
        view.addSubview(titleContentView)
        view.backgroundColor = UIColor.red
    }
}

