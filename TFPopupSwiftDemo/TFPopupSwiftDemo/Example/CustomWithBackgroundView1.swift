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
        
        self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: -self.size.height),size: size)
        
        UIView.animate(withDuration: 0.3) {
            self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0),size: self.size)
        }
        
        return super.tf_popupViewWillShow(popup)
    }
    
    
    override func tf_popupViewWillHide(_ popup: UIView!) -> Bool {
        
        UIView.animate(withDuration: 0.3) {
            self.extension.defaultBackgroundView.frame = CGRect.init(origin: CGPoint.init(x: 0, y: self.size.height),size: self.size)
        }
        
        return super.tf_popupViewWillHide(popup)
    }
}
