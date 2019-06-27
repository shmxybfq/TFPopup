//
//  ExampleAlert.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleAlertBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleAlert : UIView
@property(nonatomic,  copy)ExampleAlertBlock block;

-(void)observerClick:(ExampleAlertBlock)block;
@end

NS_ASSUME_NONNULL_END
