//
//  ExampleNotification.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleNotificationBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleNotification : UIView
@property(nonatomic,  copy)ExampleNotificationBlock block;

-(void)observerClick:(ExampleNotificationBlock)block;
@end

NS_ASSUME_NONNULL_END
