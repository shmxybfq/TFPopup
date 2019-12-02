//
//  NormalController3.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/1.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController3: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()
    let bubbleView:BubbleView = BubbleView.loadFromXib() as! BubbleView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "泡泡"
        self.param.popupSize = CGSize.init(width: 247 * 0.5, height: 243 * 0.5)
        self.param.disuseShowPopupAlphaAnimation = true;
        self.param.disuseHidePopupAlphaAnimation = true;
    }
    
    @IBAction func allButtonActions(_ sender: UIButton) {
        let title:String = sender.title(for: .normal)!
        
        var direction:PopupDirection = .bottomLeft
        
        if title == "左下" { direction = .bottomLeft }
        if title == "左" { direction = .left }
        if title == "左上" { direction = .leftTop }
        if title == "上" { direction = .top }
        if title == "右上" { direction = .topRight }
        if title == "右" { direction = .right }
        if title == "右下" { direction = .rightBottom }
        if title == "下" { direction = .bottom }
            
        
        bubbleView.tf_showBubble(self.view, basePoint: self.view.center, bubble: direction, popupParam: param);
    }
    
    
}
