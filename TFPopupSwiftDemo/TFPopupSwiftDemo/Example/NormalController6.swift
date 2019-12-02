//
//  NormalController6.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController6: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拖动"
        
        self.param.dragAutoDissmissMinDistance = 60;//多动多少像素后触发松开手消失弹框时间，default = 80，小于设置的拖动像素时松开手弹框回到原来位置
        
        self.param.disuseShowPopupAlphaAnimation = true;
        self.param.disuseHidePopupAlphaAnimation = true;
        param.popupSize = CGSize.init(width: 300, height: 310)
    }
    
    @IBAction func slideDrag(_ sender: Any) {
        
        param.dragEnable = true//在滑动弹出的情况下只需要打开拖动属性即可获得拖动功能，但仅限于向弹出的方向拖动
        param.dragBouncesEnable = true // 拖动反方向时是否支持弹性效果
        
        let oneView = UniversalView.loadFromXib()
        oneView?.tf_showSlide(self.view, direction: .bottom, popupParam: param)
        
    }
    
    
    @IBAction func otherDrag(_ sender: Any) {
        
        param.dragEnable = true//在滑动弹出的情况下只需要打开拖动属性即可获得拖动功能，但仅限于向弹出的方向拖动
        param.dragStyle = DragStyle(rawValue: DragStyle.toRight.rawValue | DragStyle.toBottom.rawValue | DragStyle.toLeft.rawValue | DragStyle.toTop.rawValue)! //设置拖动方向
        
        let oneView = UniversalView.loadFromXib()
        oneView?.tf_showScale(self.view, offset: CGPoint.zero, popupParam: param)
        
    }
}
