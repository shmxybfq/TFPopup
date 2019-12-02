//
//  NormalController2.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/1.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController2: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    let whPercent:CGFloat = 414 / 316.0
    var targetFrame: CGRect {
        get {
            let w = UIScreen.main.bounds.size.width
            let h = w / whPercent
            return CGRect.init(x: 0, y: self.menuView.frame.height, width: w, height: h)
        }
    }
    
    let param:TFPopupParam = TFPopupParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "折叠"
        self.param.disuseShowPopupAlphaAnimation = true;
        self.param.disuseHidePopupAlphaAnimation = true;
    }
    
    
    @IBAction func bottomToTop(_ sender: Any) {
        
        let view:TopBottomFoldView = TopBottomFoldView.loadFromXib() as! TopBottomFoldView
        view.tf_showFold(self.view, targetFrame: targetFrame, direction: .bottom, popupParam: param)
    }
    
    @IBAction func leftToRight(_ sender: Any) {
        let view:TopBottomFoldView = TopBottomFoldView.loadFromXib() as! TopBottomFoldView
        view.tf_showFold(self.view, targetFrame: targetFrame, direction: .left, popupParam: param)
    }
    
    @IBAction func topToBottom(_ sender: Any) {
        let view:TopBottomFoldView = TopBottomFoldView.loadFromXib() as! TopBottomFoldView
        view.tf_showFold(self.view, targetFrame: targetFrame, direction: .top, popupParam: param)
    }
    
    @IBAction func rightToLeft(_ sender: Any) {
        let view:TopBottomFoldView = TopBottomFoldView.loadFromXib() as! TopBottomFoldView
        view.tf_showFold(self.view, targetFrame: targetFrame, direction: .right, popupParam: param)
    }
    
}
