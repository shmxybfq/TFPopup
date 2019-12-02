//
//  NormalController0.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/30.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

class NormalController0: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "普通"
        // Do any additional setup after loading the view.
    }

    @IBAction func noAnimaitonPopup(_ sender: Any) {
        UniversalView.loadFromXib()?.tf_showNormal(self.view, animated: false)
    }
    
    @IBAction func animaitonPopup(_ sender: Any) {
        UniversalView.loadFromXib()?.tf_showNormal(self.view, animated: true)
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
