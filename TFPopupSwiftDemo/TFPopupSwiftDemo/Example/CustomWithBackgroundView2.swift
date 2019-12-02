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
    
    override func tf_popupBackgroundViewCount(_ popup: UIView!) -> Int {
        return 1;
    }
    override func tf_popupView(_ popup: UIView!, backgroundViewAt index: Int) -> UIView! {
        let bgButton:UIButton = UIButton.init(type: .custom)
        bgButton.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .normal)
        bgButton.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .highlighted)
        bgButton.addTarget(self, action: #selector(bgTouch), for: .touchUpInside)
        return bgButton
    }
    override func tf_popupView(_ popup: UIView!, backgroundViewFrameAt index: Int) -> CGRect {
        return UIScreen.main.bounds;
    }
    
    @objc func bgTouch() {
        self.tf_hide()
    }
    
}
