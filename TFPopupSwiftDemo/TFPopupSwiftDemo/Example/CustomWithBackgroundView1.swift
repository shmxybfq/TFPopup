//
//  CustomWithBackgroundView1.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class CustomWithBackgroundView1: CustomBaseView {
    
    let size:CGSize = UIScreen.main.bounds.size
    
    override func tf_popupViewWillShow(_ popup: UIView!) -> Bool {
        
        //在这里可以拿到背景view，可以在将要弹出前对其进行更改
        self.extension.defaultBackgroundView.backgroundColor = UIColor.brown
        
        self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -self.size.height),size: size)
        
        UIView.animate(withDuration: 0.5) {
            self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0),size: self.size)
        }
        
        return super.tf_popupViewWillShow(popup)
        
    }
    
    
    override func tf_popupViewWillHide(_ popup: UIView!) -> Bool {
        
        //在这里可以拿到背景view，可以在将要消失前对其进行更改
        self.extension.defaultBackgroundView.backgroundColor = UIColor.red
        
        UIView.animate(withDuration: 0.5) {
            self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.size.height),size: self.size)
        }
        
        return super.tf_popupViewWillHide(popup)
    }
}
