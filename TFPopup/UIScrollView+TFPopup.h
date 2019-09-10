//
//  UIScrollView+TFPopup.h
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TFPopupConst.h"
#import "NSObject+TFPopupMethodExchange.h"

@interface UIScrollView (TFPopup)

@property(nonatomic, assign) BOOL popupDragEnable;


@end


