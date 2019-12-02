//
//  TopView.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/30.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class TopView: UIView {

    @IBOutlet weak var mainButton: UIButton!
       
       override func awakeFromNib() {
           self.mainButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
       }
       
      
       @objc func hide(){
           self.tf_hide()
       }
}
