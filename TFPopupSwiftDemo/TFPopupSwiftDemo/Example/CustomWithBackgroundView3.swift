//
//  CustomWithBackgroundView3.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/3.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class CustomWithBackgroundView3: CustomBaseView {
    
    let bgs:NSMutableArray = NSMutableArray.init()
    
    override func tf_popupBackgroundViewCount(_ popup: UIView!) -> Int {
        return 4;
    }
    
    override func tf_popupView(_ popup: UIView!, backgroundViewAt index: Int) -> UIView! {
        
        let bt = UIButton.init(type: .custom)
        
        bt.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .normal)
        bt.setBackgroundImage(UIImage.init(named: "popup-bg-4"), for: .highlighted)
        bt.addTarget(self, action: #selector(bgTouch), for: .touchUpInside)
        bt.backgroundColor = UIColor.red
        
        bgs.add(bt)
        
        return bt
    }
    override func tf_popupView(_ popup: UIView!, backgroundViewFrameAt index: Int) -> CGRect {
        
        let size:CGSize = UIScreen.main.bounds.size
        let w = size.width * 0.5
        let h = size.height * 0.5
        
        var frame:CGRect? = CGRect.zero
        
        switch index {
            
        case 0:
            frame = CGRect.init(x: -w, y: -h, width: w, height: h)
        case 1:
            frame = CGRect.init(x: size.width, y: -h, width: w, height: h)
        case 2:
            frame = CGRect.init(x: -w, y: size.height, width: w, height: h)
        case 3:
            frame = CGRect.init(x: size.width, y: size.height, width: w, height: h)
        default :
            print( "默认 case")
        }
        return frame!
    }
    
    @objc func bgTouch() {
        self.tf_hide()
    }
    
    override func tf_popupViewWillShow(_ popup: UIView!) -> Bool {

        let size:CGSize = UIScreen.main.bounds.size;
        let w = size.width * 0.5
        let h = size.height * 0.5

        for (index,_) in self.bgs.enumerated() {

            let bt:UIButton = self.bgs.object(at: index) as! UIButton
            var frame:CGRect? = CGRect.zero

            switch index {
            case 0:
                frame = CGRect.init(x: 0, y: 0, width: w, height: h)
            case 1:
                frame = CGRect.init(x: w, y: 0, width: w, height: h)
            case 2:
                frame = CGRect.init(x: 0, y: h, width: w, height: h)
            case 3:
                frame = CGRect.init(x: w, y: h, width: w, height: h)
            default :
                print( "默认 case")
            }
            
            //这里框架有个bug，不延时情况下改变属性无效
            let time: TimeInterval = 0.01
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                UIView.animate(withDuration: 0.3) {
                    bt.frame = frame!
                }
            }
        }
        return super.tf_popupViewWillShow(popup)
    }



    override func tf_popupViewWillHide(_ popup: UIView!) -> Bool {

        let size:CGSize = UIScreen.main.bounds.size;
        let w = size.width * 0.5
        let h = size.height * 0.5

        for (index,_) in bgs.enumerated() {

            let bt:UIButton = bgs.object(at: index) as! UIButton
            var frame:CGRect? = CGRect.zero

            UIView.animate(withDuration: 0.3) {
                switch index {
                case 0:
                    frame = CGRect.init(x: -w, y: -h, width: w, height: h)
                case 1:
                    frame = CGRect.init(x: size.width, y: -h, width: w, height: h)
                case 2:
                    frame = CGRect.init(x: -w, y: size.height, width: w, height: h)
                case 3:
                    frame = CGRect.init(x: size.width, y: size.height, width: w, height: h)
                default :
                    print( "默认 case")
                }
                
                //这里框架有个bug，不延时情况下改变属性无效
                let time: TimeInterval = 0.01
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    UIView.animate(withDuration: 0.3) {
                        bt.frame = frame!
                    }
                }
            }
        }
        return super.tf_popupViewWillHide(popup)
    }
}
