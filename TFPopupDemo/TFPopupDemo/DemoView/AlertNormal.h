//
//  AlertNormal.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface AlertNormal : UIView

@property(nonatomic,  copy)ActionBlock block;

-(void)observerSure:(ActionBlock)block;

@end

NS_ASSUME_NONNULL_END
