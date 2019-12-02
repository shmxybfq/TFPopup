//
//  NormalController7.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import TFPopup

class NormalController7: UIViewController {
    
    let param:TFPopupParam = TFPopupParam()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置参数自定义动画"
        param.popupSize = CGSize.init(width: 300, height: 310)
        param.disuseShowPopupAlphaAnimation = true;
        param.disuseHidePopupAlphaAnimation = true;
    }
    
    @IBAction func allButtonActions(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        let buttonTitle:String = sender.title(for: .normal)!
        
        
        
        if buttonTitle == "弹出过程携带参数"{
            self.param.object1 = sender.isSelected ? "我是携带参数" : nil
        }
        
        
        if buttonTitle == "动画时间1s"{
            self.param.duration = sender.isSelected ? 1.0 : 0.3
        }
        
        
        if buttonTitle == "动画开始延时示例1s"{
            self.param.showAnimationDelay = sender.isSelected ? 1.0 : 0.3
        }
        
        
        if buttonTitle == "动画结束延时示例1s"{
            self.param.hideAnimationDelay = sender.isSelected ? 1.0 : 0.3
        }
        
        
        if buttonTitle == "自动消失时间示例1s"{
            self.param.autoDissmissDuration = sender.isSelected ? 1.0 : 0.3
        }
        
        
        if buttonTitle == "禁止使用背景"{
            self.param.disuseBackground = sender.isSelected
        }
        
        
        if buttonTitle == "使用背景色透明"{
            self.param.backgroundColorClear = sender.isSelected
        }
        
        
        if buttonTitle == "禁止点击背景消失"{
            self.param.disuseBackgroundTouchHide = sender.isSelected
        }
        
        
        if buttonTitle == "禁止显示时背景渐隐"{
            self.param.disuseShowBackgroundAlphaAnimation = sender.isSelected
        }
        
        if buttonTitle == "禁止消失时背景渐隐"{
            self.param.disuseHideBackgroundAlphaAnimation = sender.isSelected
        }
        
        
        if buttonTitle == "设置拖拽" {
            self.param.dragEnable = true
            self.param.dragStyle = DragStyle(rawValue: DragStyle.toRight.rawValue | DragStyle.toBottom.rawValue)! //设置拖动方向
        }
        
        
        if buttonTitle == "禁用显示渐隐动画"{
            self.param.disuseShowPopupAlphaAnimation = sender.isSelected
        }
        
        if buttonTitle == "禁用消失渐隐动画"{
            self.param.disuseHidePopupAlphaAnimation = sender.isSelected
        }
        
        
        if buttonTitle == "位置偏移示例"{
            self.param.offset = CGPoint.init(x: -50, y: 100)//在原来位置左偏移50，下偏移100
        }
        
        
        if buttonTitle == "选择属性动画0"{
            if sender.isSelected {
                self.param.showKeyPath = "transform.rotation.z"//transform.rotation.x,transform.rotation.y 分别有不同的效果
                self.param.showFromValue = NSNumber.init(value: 0)
                self.param.showToValue = NSNumber.init(value: Double.pi * 2)
            }else{
                self.param.showKeyPath = nil
                self.param.showFromValue = nil
                self.param.hideToValue = nil
            }
        }
        
        
        if buttonTitle == "选择属性动画1"{
            if sender.isSelected {
                self.param.showKeyPath = "transform.scale.y"//transform.scale.x,transform.scale.z 分别有不同的效果
                self.param.showFromValue = NSNumber.init(value: 0)
                self.param.showToValue = NSNumber.init(value: 0.6)
            }else{
                self.param.showKeyPath = nil
                self.param.showFromValue = nil
                self.param.hideToValue = nil
            }
        }
        
    }
    
    @IBAction func show() {
        UniversalView.loadFromXib()?.tf_showNormal(self.view, popupParam: self.param)
    }
    
}

