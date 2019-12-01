//
//  NormalController5.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/1.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController5: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "遮罩"
        self.param.disuseShowPopupAlphaAnimation = true;
        self.param.disuseHidePopupAlphaAnimation = true;
    }
    
    
    
    @IBAction func triangleToTop(_ sender: Any) {
        
        let width:CGFloat = 300
        let height:CGFloat = 310

        let bez0:UIBezierPath = UIBezierPath.init()
        bez0.move(to: CGPoint.init(x: width * 0.5, y: height))
        bez0.addLine(to: CGPoint.init(x: 0, y: height + 50))
        bez0.addLine(to: CGPoint.init(x: 0, y: height + 100))
        bez0.addLine(to: CGPoint.init(x: width, y: height + 100))
        bez0.addLine(to: CGPoint.init(x: width, y: height + 50))
        bez0.close()

        let bez1:UIBezierPath = UIBezierPath.init()
        bez1.move(to: CGPoint.init(x: width * 0.5, y: -50))
        bez1.addLine(to: CGPoint.init(x: 0, y: 0))
        bez1.addLine(to: CGPoint.init(x: 0, y: height))
        bez1.addLine(to: CGPoint.init(x: width, y: height))
        bez1.addLine(to: CGPoint.init(x: width, y: 0))
        bez1.close()
        
        let bez2:UIBezierPath = UIBezierPath.init(ovalIn: CGRect.init(x: -100, y: -100, width: width + 200, height: height + 200))
        
        let bez3:UIBezierPath = UIBezierPath.init(ovalIn: CGRect.init(x: (width - 2) * 0.5, y: (height - 2) * 0.5, width: 2, height: 2))
        
        self.param.maskShowFromPath = bez0
        self.param.maskShowToPath = bez1
        
        self.param.maskHideFromPath = bez2
        self.param.maskHideToPath = bez3
        
        param.popupSize = CGSize.init(width: width, height: height)
        let oneView = UniversalView.loadFromXib()
        oneView?.tf_showMask(self.view, popupParam: param)
    }
    
    
    
    
}
