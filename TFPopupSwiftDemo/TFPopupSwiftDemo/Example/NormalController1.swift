//
//  NormalController1.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/30.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let window = UIApplication.shared.windows.last
    
    @IBAction func bottomToTop(_ sender: Any) {
        let param:TFPopupParam = TFPopupParam()
        BottomView.loadFromXib()?.tf_showSlide(self.view, direction: .bottom, popupParam: param)
    }
    
    @IBAction func leftToRight(_ sender: Any) {
        let param:TFPopupParam = TFPopupParam()
        param.popupSize = CGSize.init(width: 250, height: UIScreen.main.bounds.size.height)
        LeftRightView.loadFromXib()?.tf_showSlide(window, direction: .left, popupParam: param)
    }
    
    @IBAction func topToBottom(_ sender: Any) {
        let param:TFPopupParam = TFPopupParam()
        param.popupSize = CGSize.init(width: UIScreen.main.bounds.size.width, height:114)
        TopView.loadFromXib()?.tf_showSlide(window, direction: .top, popupParam: param)
    }
    
    @IBAction func rightToLeft(_ sender: Any) {
        let param:TFPopupParam = TFPopupParam()
        param.popupSize = CGSize.init(width: 250, height: UIScreen.main.bounds.size.height)
        LeftRightView.loadFromXib()?.tf_showSlide(window, direction: .right, popupParam: param)
    }
    
    
}
