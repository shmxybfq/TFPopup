//
//  UIView_ExtensionSystem.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/30.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit
import Foundation

extension UIView{
    
    public class func loadFromXib() -> UIView?{
        let vs = Bundle.main.loadNibNamed("\(self.classForCoder())", owner: nil, options: nil)
        if let views:Array = vs{
            if views.count > 0 {
                return views.first as? UIView
            }
        }
        return nil
    }
}
