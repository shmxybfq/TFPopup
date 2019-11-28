//
//  AppDelegate.swift
//  TFPopupSwiftDemo
//
//  Created by zhutaofeng on 2019/11/28.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    @objc var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainController:UIViewController = MainController.init()
        
        let mainNavController = MainNavigationController.init(rootViewController: mainController)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        self.window?.rootViewController = mainNavController;
                
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    
}

