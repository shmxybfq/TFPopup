//
//  CustomBaseView.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/12/2.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class CustomBaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageView:UIImageView = UIImageView.init(image: UIImage.init(named: "popup-1"))
        self.addSubview(imageView)
        imageView.snp.remakeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
