//
//  CustomController0.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class CustomController0: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义-背景"
        self.param.popupSize = CGSize.init(width: 300, height: 310)
        self.param.disuseShowPopupAlphaAnimation = false;
        self.param.disuseHidePopupAlphaAnimation = false;
    }
    
    @IBAction func allButtonActions(_ sender: UIButton) {
        let title:String = sender.title(for: .normal)!
        
        if title == "重定义背景事件"{
            CustomWithBackgroundView0.init().tf_showScale(self.view, offset: CGPoint.zero, popupParam: self.param)
        }
        
        if title == "示例:重定义背景动画"{
            CustomWithBackgroundView1.init().tf_showScale(self.view, offset: CGPoint.zero, popupParam: self.param)
        }
        
        if title == "背景view自定义"{
            CustomWithBackgroundView2.init().tf_showScale(self.view, offset: CGPoint.zero, popupParam: self.param)
        }
        
        
    }
}
