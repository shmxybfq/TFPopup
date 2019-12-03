//
//  CustomWithBackgroundView2.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class CustomWithBackgroundView2: CustomBaseView {
    
    let bgButton:UIButton = UIButton.init(type: .custom)
    
    override func tf_popupBackgroundViewCount(_ popup: UIView!) -> Int {
        return 1;
    }
    override func tf_popupView(_ popup: UIView!, backgroundViewAt index: Int) -> UIView! {
        self.bgButton.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .normal)
        self.bgButton.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .highlighted)
        self.bgButton.addTarget(self, action: #selector(bgTouch), for: .touchUpInside)
        self.bgButton.alpha = 0;
        return self.bgButton
    }
    override func tf_popupView(_ popup: UIView!, backgroundViewFrameAt index: Int) -> CGRect {
        return UIScreen.main.bounds;
    }
    
    @objc func bgTouch() {
        self.tf_hide()
    }
    
    //弹出时背景渐隐
    override func tf_popupViewWillShow(_ popup: UIView!) -> Bool {
        
        UIView.animate(withDuration: 0.3) {
            self.bgButton.alpha = 1.0;
        }
        
        return super.tf_popupViewWillShow(popup)
    }
    
    
    //消失时背景渐隐
    override func tf_popupViewWillHide(_ popup: UIView!) -> Bool {
        
        UIView.animate(withDuration: 0.3) {
            self.bgButton.alpha = 0.0;
        }
        
        return super.tf_popupViewWillHide(popup)
    }
}
