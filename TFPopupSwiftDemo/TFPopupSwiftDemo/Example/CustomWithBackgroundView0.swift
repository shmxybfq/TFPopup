//
//  CustomWithBackgroundView0.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class CustomWithBackgroundView0: CustomBaseView,UIAlertViewDelegate {

    //重写父类tf_popupViewBackgroundDidTouch
    override func tf_popupViewBackgroundDidTouch(_ popup: UIView!) -> Bool {
        self.observerBackgroundViewTouch()
        return false
    }
    
    
    func observerBackgroundViewTouch() {
        let title:String = "自定义背景点击事件"
        let msg:String = "子类重写【tf_popupViewBackgroundDidTouch】方法"
        let alert:UIAlertView = UIAlertView.init(title: title,
                                                 message: msg,
                                                 delegate: self,
                                                 cancelButtonTitle: "确定")
        alert.show()
    }
    
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.tf_hide()
    }
    

}
