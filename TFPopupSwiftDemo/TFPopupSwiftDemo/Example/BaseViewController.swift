//
//  BaseViewController.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/28.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        let startButton = UIButton.init(type: UIButton.ButtonType.custom)
        startButton.backgroundColor = UIColor.brown
        startButton.setTitle("点我", for: UIControl.State.normal)
        startButton.addTarget(self, action: #selector(startButtonClick(ins:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
    
    @objc func startButtonClick(ins:UIButton){
        print("class:\(self.classForCoder) not override fuc \(#function)")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
