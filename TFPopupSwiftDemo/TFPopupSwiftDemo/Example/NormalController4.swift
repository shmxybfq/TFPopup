//
//  NormalController4.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/1.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController4: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()
    
    let width:CGFloat = 300
    let height:CGFloat = 310
    let size:CGSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "位置+尺寸"
        self.param.disuseShowPopupAlphaAnimation = true;
        self.param.disuseHidePopupAlphaAnimation = true;
    }
    
    
    
    @IBAction func frameChange(_ sender: Any) {
        
        let from:CGRect = CGRect.init(x: -width, y: (size.height - height) * 0.5, width: width, height: height)
        let to:CGRect = CGRect.init(x: (size.width - width) * 0.5, y: (size.height - height) * 0.5, width: width, height: height)
        
        UniversalView.loadFromXib()?.tf_showFrame(self.view, from: from, to: to, popupParam: param)
        
    }
    
    @IBAction func frameAndSizeChange(_ sender: Any) {
        
        self.param.disuseShowPopupAlphaAnimation = false;
        self.param.disuseHidePopupAlphaAnimation = false;
    
        let halfW = width * 0.5
        let halfH = height * 0.5
        
        let from:CGRect = CGRect.init(x: (size.width - halfW) * 0.5, y: (size.height - halfH) * 0.5, width: halfW, height: halfH)
        let to:CGRect = CGRect.init(x: (size.width - width) * 0.5, y: (size.height - height) * 0.5, width: width, height: height)
        
        //对frame的大小做动画时要考虑subviews的变化，这里为了突出效果使用了一个没有子视图的view
        let view = UIView.init()
        view.backgroundColor = UIColor.brown
        view.tf_showFrame(self.view, from: from, to: to, popupParam: param)
    }
    
}
